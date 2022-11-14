from pycparser import c_ast

from utils.data.swift_decls import (
    SwiftExtensionDecl,
    SwiftMemberDecl,
    SwiftMemberVarDecl,
)


class SymbolGeneratorFilter:
    def should_gen_enum_extension(
        self, node: c_ast.Enum, decl: SwiftExtensionDecl
    ) -> bool:
        return not decl.is_empty()

    def should_gen_enum_member(
        self, node: c_ast.Enumerator, decl: SwiftMemberDecl
    ) -> bool:
        return True

    def should_gen_enum_var_member(
        self, node: c_ast.Enumerator, decl: SwiftMemberVarDecl
    ) -> bool:
        return self.should_gen_enum_member(node, decl)

    def should_gen_struct_extension(
        self, node: c_ast.Struct, decl: SwiftExtensionDecl
    ) -> bool:
        return not decl.is_empty()
