from utils.data.compound_symbol_name import CompoundSymbolName
from utils.data.swift_decls import (
    CDeclKind,
    SwiftExtensionDecl,
    SwiftMemberDecl,
    SwiftMemberFunctionDecl,
)
from utils.generator.swift_conformance_generator import SwiftConformanceGenerator
from pycparser import c_ast


class SwiftEquatableConformance(SwiftConformanceGenerator):
    """
    Generates 'Equatable' conformance for a struct type.

    Sample: Original C struct:

    ```c
    struct Sample {
        uint32_t field0;
        uint32_t field1;
    }
    ```

    Generated extension:

    ```swift
    extension Sample: Equatable { }

    public extension Sample {
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.field0 == rhs.field0 && lhs.field1 == rhs.field1
        }
    }
    ```
    """

    def __init__(self) -> None:
        self.protocol_name = "Equatable"

    def generate_members(
        self, decl: SwiftExtensionDecl, node: c_ast.Node
    ) -> list[SwiftMemberDecl]:

        if not isinstance(node, c_ast.Struct):
            return []

        body: list[str] = list()

        field_comparisons: list[str] = list()
        if node.decls is not None:
            field_comparisons = list(
                # Create equality expression for field
                map(
                    lambda field: f"lhs.{field} == rhs.{field}",
                    self.iterate_field_names(
                        node.name,
                        node.decls,
                        ignore_non_constant_tuples=True,
                        max_tuple_length=8,
                    ),
                )
            )

        if len(field_comparisons) == 0:
            return []

        body = [" && ".join(field_comparisons)]

        return [
            SwiftMemberFunctionDecl(
                CompoundSymbolName.from_string_list("==").adding_component(
                    string="", suffix=" "
                ),
                original_name=None,
                origin=None,
                original_node=None,
                c_kind=CDeclKind.NONE,
                doccomment=None,
                is_static=True,
                arguments=[
                    (None, "lhs", "Self"),
                    (None, "rhs", "Self"),
                ],
                return_type="Bool",
                body=body,
            )
        ]
