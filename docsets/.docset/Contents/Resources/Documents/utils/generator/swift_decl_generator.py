from pathlib import Path

from pycparser import c_ast
from utils.data.compound_symbol_name import CompoundSymbolName
from utils.data.swift_decls import (
    CDeclKind,
    SourceLocation,
    SwiftDecl,
    SwiftExtensionDecl,
    SwiftMemberVarDecl,
)
from utils.generator.symbol_generator_filter import SymbolGeneratorFilter
from utils.generator.symbol_name_generator import SymbolNameGenerator


# Visitor / declaration collection


class SwiftDeclGenerator:
    def __init__(
        self,
        prefixes: list[str],
        symbol_filter: SymbolGeneratorFilter,
        symbol_name_generator: SymbolNameGenerator,
    ):
        self.prefixes = prefixes
        self.symbol_filter = symbol_filter
        self.symbol_name_generator = symbol_name_generator

    def coord_to_location(self, coord) -> SourceLocation:
        return SourceLocation(Path(coord.file), coord.line, coord.column)

    # Enum

    def generate_enum_case(
        self,
        enum_name: CompoundSymbolName,
        enum_original_name: str,
        node: c_ast.Enumerator,
    ) -> SwiftMemberVarDecl | None:

        value = self.symbol_name_generator.generate_original_enum_case(node.name).to_string()

        return SwiftMemberVarDecl(
            self.symbol_name_generator.generate_enum_case(
                enum_name, enum_original_name, node.name
            ),
            self.symbol_name_generator.generate_original_enum_case(node.name),
            self.coord_to_location(node.coord),
            original_node=node,
            c_kind=CDeclKind.ENUM_CASE,
            doccomment=None,
            is_static=True,
            initial_value=value
        )

    def generate_enum(self, result: list[SwiftDecl], node: c_ast.Enum, suggested_name: str | None):
        decl_name = suggested_name if node.name is None else node.name

        enum_name = self.symbol_name_generator.generate_enum_name(
            decl_name
        )

        members = []
        if node.values is not None:
            for case_node in node.values:
                case_decl = self.generate_enum_case(enum_name, decl_name, case_node)
                if case_decl is None:
                    continue

                if self.symbol_filter.should_gen_enum_var_member(case_node, case_decl):
                    members.append(case_decl)

        decl = SwiftExtensionDecl(
            enum_name,
            self.symbol_name_generator.generate_original_enum_name(decl_name),
            self.coord_to_location(node.coord),
            original_node=node,
            c_kind=CDeclKind.ENUM,
            doccomment=None,
            members=list(members),
            conformances=[],
        )

        if self.symbol_filter.should_gen_enum_extension(node, decl):
            result.append(decl)

    # Struct

    def generate_struct(self, result: list[SwiftDecl], node: c_ast.Struct, suggested_name: str | None):
        decl_name = suggested_name if node.name is None else node.name

        struct_name = self.symbol_name_generator.generate_struct_name(
            decl_name
        )

        decl = SwiftExtensionDecl(
            struct_name,
            self.symbol_name_generator.generate_original_struct_name(decl_name),
            self.coord_to_location(node.coord),
            original_node=node,
            c_kind=CDeclKind.STRUCT,
            doccomment=None,
            members=[],
            conformances=[],
        )

        if self.symbol_filter.should_gen_struct_extension(node, decl):
            result.append(decl)
    
    #

    def generate(self, result: list[SwiftDecl], node: c_ast.Node, suggested_name: str | None = None):
        match node:
            case c_ast.Typedef():
                if isinstance(node.type, c_ast.TypeDecl):
                    self.generate(
                        result,
                        node.type.type,
                        suggested_name=node.name
                    )
            
            case c_ast.Enum():
                self.generate_enum(result, node, suggested_name)

            case c_ast.Struct():
                self.generate_struct(result, node, suggested_name)

    def generate_from_list(self, nodes: list[c_ast.Node]) -> list[SwiftDecl]:
        result: list[SwiftDecl] = []
        for node in nodes:
            decl = self.generate(result, node)
            if decl is not None:
                result.append(decl)

        return result

    def post_merge(self, decls: list[SwiftDecl]) -> list[SwiftDecl]:
        "Applies post-type merge operations to a list of Swift declarations"

        return decls
