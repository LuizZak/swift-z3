from pathlib import Path
from dataclasses import dataclass
import re
from typing import Callable, Iterable


@dataclass(frozen=True)
class DoccommentBlock:
    """
    A block of doc comments, with one or more printable line of text.
    """

    file: Path
    "Path for file that originally contained this doc comment."

    line: int
    "Line in `self.file` that contained this doc comment."

    column: int
    "Column in `self.file` that contained this doc comment."

    comment_contents: str
    """
    The contents of the doc comment, potentially with multiple lines of text.
    
    May not be the same contents, if customized by a doccomment formatter.
    """

    def copy(self) -> "DoccommentBlock":
        return DoccommentBlock(
            file=self.file,
            line=self.line,
            column=self.column,
            comment_contents=self.comment_contents,
        )

    def contains_line(self, line_index: int) -> bool:
        return line_index >= self.line and line_index < (
            self.line + self.total_line_span()
        )

    def total_line_span(self) -> int:
        return self.comment_contents.count("\n") + 1

    def is_multi_lined(self) -> bool:
        return self.total_line_span() > 1

    def lines(self) -> list[str]:
        "Returns the comment lines associated with this doc comment block."
        return self.comment_contents.splitlines()

    def line_index_at(self, char_index: int) -> int:
        return self.comment_contents.count("\n", 0, char_index) + 1

    def line_break_indices(self) -> list[int]:
        "Returns the string index where each line in `self.comment_contents` starts at."

        result = []
        acc = 0
        for line in self.comment_contents.splitlines(keepends=True):
            result.append(acc)
            acc += len(line)

        return result

    def with_contents(self, contents: str) -> "DoccommentBlock":
        return DoccommentBlock(
            file=self.file,
            line=self.line,
            column=self.column,
            comment_contents=contents,
        )

    def with_lines(self, lines: Iterable[str]) -> "DoccommentBlock":
        return DoccommentBlock(
            file=self.file,
            line=self.line,
            column=self.column,
            comment_contents="\n".join(lines),
        )

    def replace(self, old: str, new: str) -> "DoccommentBlock":
        return self.with_contents(
            self.comment_contents.replace(old, new),
        )

    def sub(
        self,
        pattern: re.Pattern,
        repl: str | Callable[[re.Match[str]], str],
    ) -> "DoccommentBlock":

        return self.with_contents(
            pattern.sub(repl, self.comment_contents),
        )

    def merging(self, other: "DoccommentBlock") -> "DoccommentBlock":
        """
        Merges this doc comment by appending a given doc comment block to this
        block, with a new line separating the two.
        """
        min_line = self if self.line < other.line else other

        return DoccommentBlock(
            file=self.file,
            line=min_line.line,
            column=min_line.column,
            comment_contents=self.comment_contents + "\n" + other.comment_contents,
        )

    def normalize_indentation(self, start_index: int = 0) -> "DoccommentBlock":
        def indent_level(line: str) -> int:
            if len(line.strip()) == 0:
                return -1

            newline_removed = line.lstrip("\n")

            return len(newline_removed) - len(newline_removed.lstrip())

        def de_indent(line: str, level: int) -> str:
            return line[:level].lstrip() + line[level:]

        if not self.is_multi_lined():
            return self

        # Use shallowest indentation for re-indenting
        lines = self.lines()
        indents = list(filter(lambda i: i >= 0, map(indent_level, lines[start_index:])))

        if len(indents) == 0:
            return self

        shallowest = min(indents)

        # Re-join at shallowest indentation level
        return self.with_lines(map(lambda line: de_indent(line, shallowest), lines))

    @classmethod
    def merge(
        cls, first: "DoccommentBlock | None", second: "DoccommentBlock | None"
    ) -> "DoccommentBlock | None":
        if first is None:
            return second
        if second is None:
            return first

        return first.merging(second)

    @classmethod
    def merge_list(cls, docs: "Iterable[DoccommentBlock]") -> "DoccommentBlock | None":
        docs_list = list(docs)

        if len(docs_list) == 0:
            return None

        result = docs_list[0]

        for doc in docs_list[1:]:
            result = result.merging(doc)

        return result

    @classmethod
    def from_string(cls, string: str) -> "DoccommentBlock":
        return DoccommentBlock(file=Path(), line=1, column=1, comment_contents=string)
