from utils.data.compound_symbol_name import CompoundSymbolName
from utils.data.swift_decls import (
    CDeclKind,
    SwiftExtensionDecl,
    SwiftMemberDecl,
    SwiftMemberVarDecl,
)
from utils.generator.swift_conformance_generator import SwiftConformanceGenerator
from pycparser import c_ast


class SwiftCustomStringConvertibleConformance(SwiftConformanceGenerator):
    """
    Generates 'CustomStringConvertible' conformance for a struct type.

    Sample: Original C struct:

    ```c
    struct Sample {
        uint32_t field0;
        uint32_t field1;
    }
    ```

    Generated extension:

    ```swift
    extension Sample: CustomStringConvertible { }

    public extension Sample {
        var description: String {
            "Sample(field0: \\(field0), field1: \\(field1))"
        }
    }
    ```
    """

    def __init__(self) -> None:
        self.protocol_name = "CustomStringConvertible"

    def generate_members(
        self, decl: SwiftExtensionDecl, node: c_ast.Node
    ) -> list[SwiftMemberDecl]:

        if not isinstance(node, c_ast.Struct):
            return []

        accessor: list[str] = list()

        fields: str = ""
        if node.decls is not None:
            fields = ", ".join(
                # Add interpolation for field
                map(
                    lambda field: f"{field}: \\({field})",
                    self.iterate_field_names(
                        node.name,
                        node.decls,
                        ignore_non_constant_tuples=True,
                    ),
                )
            )

        accessor = [f'"{node.name}({fields})"']

        return [
            SwiftMemberVarDecl(
                name=CompoundSymbolName.from_string_list("description"),
                original_name=None,
                origin=None,
                original_node=None,
                c_kind=CDeclKind.NONE,
                doccomment=None,
                is_static=False,
                var_type="String",
                accessor_block=accessor,
            )
        ]
