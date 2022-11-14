from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Sequence
from utils.data.swift_decl_visitor import SwiftDeclVisitor

from utils.data.swift_decls import SwiftDecl, SwiftDeclWalker
from utils.doccomment.doccomment_block import DoccommentBlock


def _split_doccomment_lines(path: Path, text_file: str, doccomment_patterns: list[str]) -> list[DoccommentBlock]:
    """
    Returns a list of comments of an input string that represent C-based single
    and multi-lined doc comments.
    """

    @dataclass
    class TemporaryComment:
        line: int
        column: int
        index: int
    
    class State(Enum):
        NORMAL = 0
        STRING = 1
        SINGLE_LINE = 2
        MULTI_LINE = 3

    result: list[DoccommentBlock] = []

    if len(text_file) < 2:
        return result

    state = State.NORMAL

    line = 1
    column = 0

    current = TemporaryComment(1, 1, 0)

    def current_start() -> int:
        return current.index

    def start_current(index: int):
        current.line = line
        current.column = column
        current.index = index

    def close_current(end_index: int, multi_line: bool):
        contents = text_file[current_start():end_index]

        for pattern in doccomment_patterns:
            if contents.startswith(pattern):
                contents = contents[len(pattern):]
                
                final = DoccommentBlock(
                    file=path,
                    line=current.line,
                    column=current.column + len(pattern),
                    comment_contents=contents
                )

                result.append(final)

                break

    for index in range(len(text_file)):
        char = text_file[index]

        if char == "\n":
            column = 0
            line += 1
        else:
            column += 1

        match state:
            case State.NORMAL:
                if char == "\"":
                    state = State.STRING
                    continue
                
                if char != "/":
                    continue
                
                next = text_file[index + 1]

                if next == "/":
                    state = State.SINGLE_LINE
                    start_current(index)
                if next == "*":
                    state = State.MULTI_LINE
                    start_current(index)
            
            case State.STRING:
                if char == "\"":
                    state = State.NORMAL
            
            case State.SINGLE_LINE:
                # End of single line
                if char == "\n":
                    close_current(index, multi_line=False)
                    state = State.NORMAL
            
            case State.MULTI_LINE:
                # End of multi-line
                if char == "*" and text_file[index + 1] == "/":
                    close_current(index, multi_line=True)
                    state = State.NORMAL
    
    # Finish any existing comment
    if state == State.SINGLE_LINE:
        close_current(index, multi_line=False)
    elif state == State.MULTI_LINE:
        close_current(index, multi_line=True)

    return result


class DoccommentLookup:
    cached_files: dict[Path, list[str]]
    cached_comments: dict[Path, list[DoccommentBlock]]

    doccomment_patterns: list[str]
    "Note: should be sorted by length in descending order"

    def __init__(self) -> None:
        self.cached_files = dict()
        self.cached_comments = dict()
        # Note: should be sorted by length in descending order
        self.doccomment_patterns = [
            "//!<",
            "//!",
            "/**",
        ]
    
    def contents_for_file(self, file_path: Path) -> list[str] | None:
        cached = self.cached_files.get(file_path)
        if cached is not None:
            return cached

        if not (file_path.exists() and file_path.is_file()):
            return None

        with open(file_path) as file:
            lines = file.readlines()
            self.cached_files[file_path] = lines

            return lines
    
    def doccomments_for_file(self, file_path: Path) -> list[DoccommentBlock] | None:
        cached = self.cached_comments.get(file_path)
        if cached is not None:
            return cached

        if not (file_path.exists() and file_path.is_file()):
            return None
        
        with open(file_path) as file:
            comments = _split_doccomment_lines(file_path, file.read(), self.doccomment_patterns)

            self.cached_comments[file_path] = comments

            return comments
    
    def doccomment_for_line(self, comments: list[DoccommentBlock], line: int) -> DoccommentBlock | None:
        for comment in comments:
            if comment.contains_line(line):
                return comment
        
        return None

    def find_doccomment(self, decl: SwiftDecl) -> DoccommentBlock | None:
        # The original node is required for this lookup.
        if decl.original_node is None or decl.origin is None:
            return None

        decl_file_path = decl.origin.file
        decl_line_num = decl.origin.line

        doc_lines = self.doccomments_for_file(decl_file_path)

        if doc_lines is None:
            return None

        # Attempt to intercept comments that are inline with the declaration
        inline = self.doccomment_for_line(doc_lines, decl_line_num)
        if inline is not None:
            return inline.normalize_indentation()

        # Collect all doc comment lines that precede the definition line
        # until we reach a line that is not a doc comment, at which case
        # return the collected doc comment lines.
        collected = []
        for i in reversed(range(decl_line_num)):
            doc = self.doccomment_for_line(doc_lines, i)

            if doc is None:
                break

            collected.append(doc)

            # Quit after multi-line doc comments
            if doc.is_multi_lined():
                break

        merged = DoccommentBlock.merge_list(reversed(collected))
        if merged is None:
            return None
        
        return merged.normalize_indentation()

    def populate_doc_comments(self, decls: Sequence[SwiftDecl]) -> list[SwiftDecl]:
        class DocCommentVisitor(SwiftDeclVisitor):
            def __init__(self, lookup: DoccommentLookup):
                self.lookup = lookup

            def generic_visit(self, decl: SwiftDecl):
                comments = self.lookup.find_doccomment(decl)
                if comments is None:
                    return super().generic_visit(decl)

                decl.doccomment = comments

                return super().generic_visit(decl)

        walker = SwiftDeclWalker(DocCommentVisitor(self))

        results = []

        for decl in decls:
            copy = decl.copy()
            walker.walk_decl(copy)
            results.append(copy)

        return results
