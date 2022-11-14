from dataclasses import dataclass
import re
from utils.doccomment.doccomment_block import DoccommentBlock


class DoccommentListPicker:
    """
    From a multi-lined doc comment, provides an interface for picking off
    markdown-styled list elements from the comment body to be used somewhere
    else.

    From a doc comment with contents:

    >>> doccomment = DoccommentBlock.from_string(
    ... \"""
    ... A list
    ...
    ... - Element: A description
    ... - Other Element: Another Description
    ... \"""
    ... )

    Picking elements result in appropriately-formatted DoccommentBlock entries
    that originate from list elements of the original doc comment lines:

    >>> picker = DoccommentListPicker(doccomment)
    >>> picker.pick("Element")
    DoccommentBlock(file=PosixPath('.'), line=4, column=1, comment_contents='A description')
    >>> picker.pick("Non Existant Element")


    After picking elements, the original doc comment can optionally be obtained
    where each picked entry has been removed:

    >>> picker.result_comment().comment_contents
    '\\nA list\\n\\n- Other Element: Another Description\\n'
    """

    @dataclass
    class Entry:
        title: str
        contents: str
        indent_level: int
        start_span: int
        end_span: int
        picked: bool

    _list_item_regex: re.Pattern
    _list_item_no_colon_regex: re.Pattern
    original: DoccommentBlock
    transformed: DoccommentBlock

    items: list[Entry]

    def __init__(self, doccomment: DoccommentBlock):
        self._list_item_regex = re.compile(r"(\s*)\-\s*([^:]+):\s*")
        self._list_item_no_colon_regex = re.compile(r"(\s*)\-\s*([^\s]+)\s*")
        self.original = doccomment
        self.transformed = doccomment.copy()
        self.items = []

        self.prepare()

    def prepare(self):
        self.items = []
        indices = self.transformed.line_break_indices()

        for index in indices:
            list_item = self._split_if_list_item(index)
            if list_item is None:
                continue

            self.items.append(list_item)

    def result_comment(self) -> DoccommentBlock:
        # Remove items from description that where picked
        contents = self.original.comment_contents

        for item in reversed(self.items):
            if item.picked:
                contents = contents[: item.start_span] + contents[item.end_span + 1 :]

        return self.original.with_contents(contents)

    def pick(self, entry: str) -> DoccommentBlock | None:
        for (index, item) in enumerate(self.items):
            if item.picked or item.title != entry:
                continue

            self.remove_entry(index)

            return DoccommentBlock(
                file=self.original.file,
                line=self.original.line_index_at(item.start_span),
                column=self.original.column,
                comment_contents=item.contents,
            ).normalize_indentation(1)

        return None

    def remove_entry(self, index: int):
        self.items[index].picked = True

    def _split_if_list_item(self, index: int) -> Entry | None:
        line_end = self.transformed.comment_contents.find("\n", index)
        if line_end == -1:
            line_end = len(self.transformed.comment_contents)

        match = self._match_list_item(index, line_end)
        if match is None:
            return None

        content_start = match.end(0)
        indent_level = len(match.group(1))
        span = self._span_of_list_entry(content_start, indent_level)

        return DoccommentListPicker.Entry(
            match.group(2),
            self.transformed.comment_contents[content_start : content_start + span],
            indent_level,
            index,
            content_start + span,
            False,
        )

    def _match_list_item(self, index: int, end: int) -> re.Match[str] | None:
        match = self._list_item_regex.match(
            self.transformed.comment_contents, index, end
        )
        if match is not None:
            return match

        return self._list_item_no_colon_regex.match(
            self.transformed.comment_contents, index, end
        )

    def _span_of_list_entry(self, start: int, indent_level: int) -> int:
        contents = self.transformed.comment_contents

        def indent_at(index: int) -> int:
            level = 0
            while index < len(contents):
                if contents[index] == "\n":
                    break
                elif contents[index] == " ":
                    level += 1
                    index += 1
                else:
                    break

            return level

        end = start
        while end < len(contents):
            if contents[end] != "\n":
                end += 1
                continue

            if end < len(contents) - 1:
                # Keep collecting empty lines as if they where indented equally.
                if contents[end + 1] == "\n":
                    end += 1
                    continue

                # For non-empty lines, check if the indentation level is increased
                # from baseline, meaning the line is a continuation of a previous
                # line
                level = indent_at(end + 1)
                if level <= indent_level:
                    break

                end += level
                if end == len(contents):
                    break

                if contents[end] != " ":
                    break

            end += 1

        return end - start


if __name__ == "__main__":
    import doctest

    doctest.testmod(optionflags=doctest.NORMALIZE_WHITESPACE)

    import unittest
    from pathlib import Path

    class TestStringMethods(unittest.TestCase):
        def test_pick(self):
            sut = self.make_sut()
            self.assertEqual(
                sut.pick("Element"),
                DoccommentBlock(
                    file=Path("."),
                    line=3,
                    column=1,
                    comment_contents="A description",
                ),
            )

        def test_pick_missing_colon(self):
            sut = self.make_sut_missing_colon()
            self.assertEqual(
                sut.pick("Element"),
                DoccommentBlock(
                    file=Path("."),
                    line=3,
                    column=1,
                    comment_contents="A description",
                ),
            )

        def test_pick_nonexisting(self):
            sut = self.make_sut()
            self.assertIsNone(sut.pick("Nonexisting"))

        def test_result_comment_pick_all(self):
            sut = self.make_sut()

            self.assertEqual(
                sut.pick("Element"),
                DoccommentBlock(
                    file=Path("."),
                    line=3,
                    column=1,
                    comment_contents="A description",
                ),
            )
            self.assertEqual(
                sut.pick("Other Element"),
                DoccommentBlock(
                    file=Path("."),
                    line=4,
                    column=1,
                    comment_contents="Another Description",
                ),
            )

            self.assertEqual(sut.result_comment().comment_contents, "A list\n\n")

        def test_result_comment_pick_all_reverse_order(self):
            sut = self.make_sut()

            self.assertIsNotNone(sut.pick("Other Element"))
            self.assertIsNotNone(sut.pick("Element"))

            self.assertEqual(sut.result_comment().comment_contents, "A list\n\n")

        def test_result_comment_multi_lined_with_line_separations(self):
            sut = self.make_sut_multi_lined_with_line_separations()

            self.assertIsNotNone(sut.pick("Element"))

            self.assertEqual(
                sut.result_comment().comment_contents,
                "A list\n\n- Other Element: Another Description",
            )

        def test_multi_lined_pick(self):
            sut = self.make_sut_multi_lined()
            self.assertEqual(
                sut.pick("Element").comment_contents,
                "A description\nContinuation of previous description",
            )

        def test_multi_lined_with_empty_break(self):
            sut = self.make_sut_multi_lined_with_empty_break()
            self.assertEqual(
                sut.pick("Element").comment_contents,
                "A description\n"
                "Continuation of previous description\n"
                "\n"
                "Another continuation line with space in between.\n"
                "   This line is nested further",
            )

        def test_pick_nested(self):
            sut = self.make_sut_nested()
            self.assertEqual(
                sut.pick("Element").comment_contents,
                "A description\n- Sub Element: Another Description",
            )

        def test_pick_indented_items(self):
            doccomment = DoccommentBlock.from_string(
                "A list\n"
                " \n"
                " - Element: A description\n"
                "    Continuation line\n"
                " \n"
                " - Other Element: Another Description"
            )
            sut = DoccommentListPicker(doccomment)

            self.assertEqual(
                sut.pick("Element").comment_contents,
                "A description\n" "Continuation line",
            )
            self.assertEqual(
                sut.result_comment().comment_contents,
                "A list\n" " \n" " \n" " - Other Element: Another Description",
            )

        # MARK: - Test object generators

        def make_sut(self):
            doccomment = DoccommentBlock.from_string(
                "A list\n"
                "\n"
                "- Element: A description\n"
                "- Other Element: Another Description"
            )

            return DoccommentListPicker(doccomment)

        def make_sut_missing_colon(self):
            doccomment = DoccommentBlock.from_string(
                "A list\n"
                "\n"
                "- Element A description\n"
                "- Other Element: Another Description"
            )

            return DoccommentListPicker(doccomment)

        def make_sut_multi_lined(self):
            doccomment = DoccommentBlock.from_string(
                "A list\n"
                "\n"
                "- Element: A description\n"
                "   Continuation of previous description\n"
                "- Other Element: Another Description"
            )

            return DoccommentListPicker(doccomment)

        def make_sut_multi_lined_with_empty_break(self):
            doccomment = DoccommentBlock.from_string(
                "A list\n"
                "\n"
                "- Element: A description\n"
                "   Continuation of previous description\n"
                "\n"
                "   Another continuation line with space in between.\n"
                "      This line is nested further\n"
                "- Other Element: Another Description"
            )

            return DoccommentListPicker(doccomment)

        def make_sut_multi_lined_with_line_separations(self):
            doccomment = DoccommentBlock.from_string(
                "A list\n"
                "\n"
                "- Element: A description\n"
                "   Continuation line\n"
                "\n"
                "- Other Element: Another Description"
            )

            return DoccommentListPicker(doccomment)

        def make_sut_nested(self):
            doccomment = DoccommentBlock.from_string(
                "A list\n"
                "\n"
                "- Element: A description\n"
                "   - Sub Element: Another Description"
            )

            return DoccommentListPicker(doccomment)

    unittest.main()
