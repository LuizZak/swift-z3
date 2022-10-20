from typing import Any, Callable, Sequence, TypeVar
from utils.data.swift_decl_lookup import SwiftDeclLookup
from utils.data.swift_decls import SwiftDecl
from utils.doccomment.doccomment_block import DoccommentBlock


class DoccommentFormatter:
    T = TypeVar("T")
    DOC_T = TypeVar("DOC_T", DoccommentBlock, str)

    def format_doccomment(
        self,
        comment: DoccommentBlock | None,
        decl: SwiftDecl,
        decl_lookup: SwiftDeclLookup,
    ) -> DoccommentBlock | None:
        if comment is None:
            return None

        # Format multi-line comments
        comment = self.format_multiline(comment)

        return comment

    def format_multiline(self, comment: DoccommentBlock) -> DoccommentBlock:
        comment = comment.normalize_indentation()

        # Use shallowest indentation for re-indenting
        lines = comment.lines()

        # Trim leading and trailing empty lines
        lines = self.trim_empty_lines(lines, lambda l: len(l.strip()) == 0)

        return comment.with_lines(lines)

    def trim_empty_lines(
        self, sequence: Sequence[T], is_empty: Callable[[T], bool]
    ) -> list[T]:

        has_content = False
        first_index: int | None = None
        last_index: int | None = None

        for (i, comment) in enumerate(sequence):
            if not is_empty(comment):
                has_content = True

                if first_index is None:
                    first_index = i
                if last_index is None or last_index < i:
                    last_index = i

        if not has_content:
            return list(sequence)

        if (first_index is not None) and (last_index is not None):
            return list(sequence[first_index : (last_index + 1)])

        return list(sequence)

    def replace_per_line(self, obj, replacer: Callable[[str], str]) -> Any | None:
        if isinstance(obj, DoccommentBlock):
            if obj.is_multi_lined():
                return obj.with_lines(map(replacer, obj.lines()))
            else:
                return obj.with_contents(replacer(obj.comment_contents))

        if isinstance(obj, list):
            return list(map(replacer, obj))

        return None
