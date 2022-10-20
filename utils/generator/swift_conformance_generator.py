from typing import Generator
from utils.cli.console_color import ConsoleColor
from utils.data.swift_decls import (
    SwiftExtensionDecl,
    SwiftMemberDecl,
)
from pycparser import c_ast


class SwiftConformanceGenerator:
    """
    Class used to generate conformances to specific Swift protocols, along with
    any required members.
    """

    protocol_name: str

    def generate_members(
        self, decl: SwiftExtensionDecl, node: c_ast.Node
    ) -> list[SwiftMemberDecl]:
        raise NotImplementedError()

    def iterate_field_names(
        self,
        type_name: str,
        fields: list[c_ast.Decl],
        ignore_non_constant_tuples: bool = False,
        max_tuple_length: int = 8,
    ) -> Generator:
        for field in fields:
            for name in self._internal_iterate_field_names(
                type_name,
                field,
                ignore_non_constant_tuples,
                max_tuple_length,
            ):
                yield name

    def _internal_iterate_field_names(
        self,
        type_name: str,
        field: c_ast.Decl,
        ignore_non_constant_tuples: bool = False,
        max_tuple_length: int = 8,
    ) -> Generator:
        """
        Iterates trough a declaration, yielding every nameable field in that
        declaration. If the declaration is a single nameable declaration, yields
        that field's name. If the declaration is a struct declaration, emits every
        field in that struct. If the declaration is a union, emits the first valid
        field within that union.
        """

        if isinstance(field.type, c_ast.Struct):
            for str_field in field.type.decls:
                if not ignore_non_constant_tuples:
                    if not self._is_constant_field_decl(str_field):
                        continue
                for f in self._internal_iterate_field_names(
                    type_name,
                    str_field,
                    ignore_non_constant_tuples,
                    max_tuple_length,
                ):
                    yield f
        if isinstance(field.type, c_ast.Union):
            for union_field in field.type.decls:
                if not ignore_non_constant_tuples:
                    if not self._is_constant_field_decl(union_field):
                        continue
                for f in self._internal_iterate_field_names(
                    type_name,
                    union_field,
                    ignore_non_constant_tuples,
                    max_tuple_length,
                ):
                    yield f
                break  # Break after first valid union field
        # For array declarations, ensure that at most 8 tuple fields are
        # present, otherwise, emit an access for each tuple element.
        elif isinstance(field.type, c_ast.ArrayDecl):
            dims: int = 0
            if isinstance(field.type.dim, c_ast.Constant):
                dims = int(field.type.dim.value)
            elif not ignore_non_constant_tuples:
                print(
                    ConsoleColor.YELLOW(
                        f"Warning: Found non-constant dimension size {field.type.dim}\n"
                        f"while iterating through fields of type {type_name}."
                    )
                )
                return
            if dims > max_tuple_length:
                for i in range(dims):
                    yield f"{field.name}.{i}"
            elif field.name is not None:
                yield field.name
        elif isinstance(field, c_ast.ArrayDecl):
            # TODO: Reduce duplication with elif above
            if isinstance(field.type, c_ast.TypeDecl):
                dims = 0
                if isinstance(field.dim, c_ast.Constant):
                    dims = int(field.dim.value)
                elif not ignore_non_constant_tuples:
                    print(
                        ConsoleColor.YELLOW(
                            f"Warning: Found non-constant dimension size {field.dim}\n"
                            f"while iterating through fields of type {type_name}."
                        )
                    )
                    return
                if dims > max_tuple_length:
                    for i in range(dims):
                        yield f"{field.type.declname}.{i}"
                elif field.type.declname is not None:
                    yield field.type.declname
        elif field.name is not None:
            yield field.name

    def _is_constant_field_decl(self, field: c_ast.Decl) -> bool:
        """
        Returns true if the given field can be resolved (in terms of type and size)
        at the definition site, without parsing extra expressions
        (such as in `type name[CONSTANT + 1]` field declarations.).

        If the field is a struct, returns true if all fields are constant fields,
        and if the field is a union, returns true if any of the fields is constant.
        """
        if isinstance(field, c_ast.Decl):
            return self._is_constant_field_decl(field.type)

        if isinstance(field, c_ast.ArrayDecl):
            if isinstance(field.dim, c_ast.Constant):
                dims = int(field.dim.value)
                return dims != 0
            return False
        if isinstance(field, c_ast.Struct):
            return all(map(self._is_constant_field_decl, field.decls))
        if isinstance(field, c_ast.Union):
            return any(map(self._is_constant_field_decl, field.decls))
        if isinstance(field.type, c_ast.TypeDecl):
            if isinstance(field.dim, c_ast.Constant):
                dims = int(field.dim.value)
                return dims != 0

        return True

    def _field_name(self, field: c_ast.Decl) -> str | None:
        # For unions, choose the first named declaration inside.
        if isinstance(field.type, c_ast.Union):
            for union_field in field.type.decls:
                if union_name := self._field_name(union_field):
                    return union_name

        return field.name
