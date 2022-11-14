from dataclasses import dataclass, field
from enum import Enum
from typing import List
from pathlib import Path

from pycparser import c_ast
from utils.converters.syntax_stream import SyntaxStream
from utils.data.compound_symbol_name import CompoundSymbolName
from utils.converters.backticked_term import backticked_term
from utils.data.swift_decl_visit_result import SwiftDeclVisitResult
from utils.data.swift_decl_visitor import SwiftDeclVisitor
from utils.doccomment.doccomment_block import DoccommentBlock


class CDeclKind(Enum):
    """
    Represents a kind of C declaration.
    """

    NONE = 0
    "No declaration associated."

    ENUM = 1
    "A C-style enum declaration."
    ENUM_CASE = 2
    "A C-style enum value declaration."
    STRUCT = 3
    "A C-style struct declaration."


@dataclass
class SourceLocation(object):
    file: Path
    line: int
    column: int | None


@dataclass
class SwiftDecl(object):
    name: CompoundSymbolName
    original_name: CompoundSymbolName | None
    origin: SourceLocation | None

    original_node: c_ast.Node | None
    """
    Original node that produced this declaration. Is None if this declaration
    is synthesized instead.
    """

    c_kind: CDeclKind

    doccomment: DoccommentBlock | None
    "A block of doc comments associated with this element."

    def write(self, stream: SyntaxStream):
        if self.doccomment is None:
            return

        comment_str = self.doccomment.comment_contents

        for line in comment_str.splitlines():
            stream.line(f"/// {line}")

    def copy(self):
        raise NotImplementedError("Must be implemented by subclasses.")

    def accept(self, visitor: SwiftDeclVisitor) -> SwiftDeclVisitResult:
        raise NotImplementedError("Must be implemented by subclasses.")

    def accept_post(self, visitor: SwiftDeclVisitor):
        raise NotImplementedError("Must be implemented by subclasses.")

    def children(self) -> list["SwiftDecl"]:
        raise NotImplementedError("Must be implemented by subclasses.")


@dataclass
class SwiftMemberDecl(SwiftDecl):
    """
    A Swift member declaration base class.
    """

    is_static: bool = False
    "Whether this is a static member."


@dataclass
class SwiftMemberVarDecl(SwiftMemberDecl):
    """
    A Swift variable member declaration.
    """

    var_type: str | None = None
    initial_value: str | None = None
    accessor_block: list[str] | None = None

    def write(self, stream: SyntaxStream):
        super().write(stream)

        stream.pre_line()

        if self.is_static:
            stream.write("static ")

        # Variables with accessors must use "var" keyword
        if self.accessor_block is None or len(self.accessor_block) == 0:
            stream.write(f"let {backticked_term(self.name.to_string())}")
        else:
            stream.write(f"var {backticked_term(self.name.to_string())}")

        if self.var_type is not None:
            stream.write(f": {self.var_type}")

        if self.initial_value is not None:
            stream.write(f" = {self.initial_value}")

        if self.accessor_block is not None and len(self.accessor_block) > 0:
            with stream.inline_block(" {"):
                for line in self.accessor_block:
                    stream.line(line)
        else:
            stream.write_then_line()

    def copy(self):
        return SwiftMemberVarDecl(
            name=self.name.copy(),
            original_name=self.original_name.copy(),
            original_node=self.original_node,
            origin=self.origin,
            c_kind=self.c_kind,
            doccomment=self.doccomment,
            is_static=self.is_static,
            var_type=self.var_type,
            initial_value=self.initial_value,
            accessor_block=self.accessor_block,
        )

    def accept(self, visitor: SwiftDeclVisitor) -> SwiftDeclVisitResult:
        return visitor.visit(self)

    def accept_post(self, visitor: SwiftDeclVisitor):
        return visitor.post_visit(self)

    def children(self) -> list["SwiftDecl"]:
        return list()


@dataclass
class SwiftMemberFunctionDecl(SwiftMemberDecl):
    """
    A Swift function member declaration.
    """

    arguments: list[tuple[str | None, str, str]] = field(default_factory=lambda: [])
    "List of function arguments, as (label, name, type)."

    return_type: str | None = None
    "Return type of function. None produces no return type (implicit Void)"

    body: list[str] = field(default_factory=lambda: [])
    "A function body to emit."

    def write(self, stream: SyntaxStream):
        super().write(stream)

        stream.pre_line()

        if self.is_static:
            stream.write("static ")

        # func <name>
        stream.write("func ")
        stream.write(backticked_term(self.name.to_string()))

        # (<argument list>)
        def arg_str(arg: tuple[str | None, str, str]) -> str:
            result = ""
            if arg[0] is not None:
                result += f"{arg[0]} "
            result += f"{arg[1]}: "
            result += arg[2]
            return result

        stream.write("(")
        stream.write(", ".join(map(arg_str, self.arguments)))
        stream.write(") ")

        if self.return_type is not None:
            stream.write(f"-> {self.return_type} ")

        self.write_body(stream)

    def write_body(self, stream: SyntaxStream):
        if len(self.body) == 0:
            stream.write_then_line("{ }")
            return

        with stream.inline_block("{"):
            for line in self.body:
                stream.line(line)

    def copy(self):
        return SwiftMemberFunctionDecl(
            name=self.name.copy(),
            original_name=self.original_name.copy(),
            original_node=self.original_node,
            origin=self.origin,
            c_kind=self.c_kind,
            doccomment=self.doccomment,
            arguments=self.arguments,
            return_type=self.return_type,
            body=list(self.body),
            is_static=self.is_static,
        )

    def accept(self, visitor: SwiftDeclVisitor) -> SwiftDeclVisitResult:
        return visitor.visit(self)

    def accept_post(self, visitor: SwiftDeclVisitor):
        return visitor.post_visit(self)

    def children(self) -> list["SwiftDecl"]:
        return list()


@dataclass
class SwiftExtensionDecl(SwiftDecl):
    members: List[SwiftMemberDecl]
    conformances: list[str]

    def write(self, stream: SyntaxStream):
        super().write(stream)

        name = self.name.to_string()

        if self.original_name is not None and name != self.original_name.to_string():
            stream.line(f"public typealias {name} = {self.original_name.to_string()}")
            stream.line()

        # Emit conformances, with no access control specifier so the code compiles
        # properly
        if len(self.conformances) > 0:
            conformance_str = ", ".join(sorted(self.conformances))

            stream.line(f"extension {name}: {conformance_str} {{ }}")
            stream.line()

        # Only emit members extension if members are present
        if len(self.members) > 0:
            member_decl = f"public extension {name}"

            if len(self.members) == 0:
                stream.line(member_decl + " { }")
                return

            with stream.block(member_decl + " {"):
                for i, member in enumerate(self.members):
                    if i > 0:
                        stream.line()

                    member.write(stream)

    def copy(self):
        return SwiftExtensionDecl(
            name=self.name.copy(),
            original_name=self.original_name.copy(),
            origin=self.origin,
            original_node=self.original_node,
            c_kind=self.c_kind,
            doccomment=self.doccomment,
            members=list(map(lambda c: c.copy(), self.members)),
            conformances=self.conformances,
        )

    def accept(self, visitor: SwiftDeclVisitor) -> SwiftDeclVisitResult:
        return visitor.visit(self)

    def accept_post(self, visitor: SwiftDeclVisitor):
        return visitor.post_visit(self)

    def children(self) -> list["SwiftDecl"]:
        return list(self.members)

    def is_empty(self) -> bool:
        """
        Returns True if this extension declaration is empty (has no members or
        conformances declared)
        """
        return len(self.members) == 0 and len(self.conformances) == 0


class SwiftDeclWalker:
    def __init__(self, visitor: SwiftDeclVisitor):
        self.visitor = visitor

    def walk_decl(self, decl: SwiftDecl):
        result = decl.accept(self.visitor)

        if result == SwiftDeclVisitResult.VISIT_CHILDREN:
            for child in decl.children():
                self.walk_decl(child)

        decl.accept_post(self.visitor)
