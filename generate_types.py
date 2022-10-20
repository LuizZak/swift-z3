# Requires Python 3.10

import argparse
import re
import sys

from pathlib import Path
from typing import Iterable, Sequence

from pycparser import c_ast
from utils.converters.default_symbol_name_formatter import DefaultSymbolNameFormatter
from utils.converters.symbol_name_formatter import SymbolNameFormatter
from utils.data.swift_decl_lookup import SwiftDeclLookup
from utils.data.swift_decls import (
    CDeclKind,
    SwiftDecl,
    SwiftExtensionDecl,
    SwiftMemberVarDecl,
)
from utils.data.swift_file import SwiftFile
from utils.directory_structure.directory_structure_manager import (
    DirectoryStructureEntry,
    DirectoryStructureManager,
)
from utils.doccomment.doccomment_block import DoccommentBlock
from utils.doccomment.doccomment_formatter import DoccommentFormatter
from utils.doccomment.doccomment_list_picker import DoccommentListPicker
from utils.doccomment.doccomment_lookup import DoccommentLookup
from utils.generator.known_conformance_generators import get_conformance_generator
from utils.generator.swift_decl_generator import SwiftDeclGenerator
from utils.generator.symbol_generator_filter import SymbolGeneratorFilter
from utils.generator.symbol_name_generator import SymbolNameGenerator
from utils.data.compound_symbol_name import ComponentCase, CompoundSymbolName

from utils.generator.type_generator import (
    DeclGeneratorTarget,
    DeclFileGeneratorStdoutTarget,
    DeclFileGeneratorDiskTarget,
    TypeGeneratorRequest,
    generate_types,
)
from utils.paths import paths

FILE_NAME = "z3.h"

Z3_PREFIXES = [
    "Z3",
]
"""
List of prefixes from Z3 declarations to convert

Will also be used as a list of terms to remove the prefix of in final declaration names.
"""

STRUCT_CONFORMANCES: list[tuple[str | re.Pattern, list[str]]] = [
    #
    ("Z3_error_code", ["Error"]),
]
"""
List of pattern matching to apply to C struct declarations along with a list of
conformances that should be appended, in case the struct matches the pattern.
"""


class Z3DeclGenerator(SwiftDeclGenerator):
    def propose_conformances(self, decl: SwiftExtensionDecl) -> list[str] | None:
        result = []

        # Match required protocols
        for req in STRUCT_CONFORMANCES:
            c_name = decl.original_name.to_string()
            match req[0]:
                case re.Pattern():
                    if not req[0].match(c_name):
                        continue
                case str():
                    if req[0] != c_name:
                        continue
            
            result.extend(req[1])
        
        return list(set(result))
    
    def post_merge(self, decls: list[SwiftDecl]) -> list[SwiftDecl]:
        result = super().post_merge(decls)

        # Use proposed conformances to generate required members
        for decl in decls:
            if conformances := self.propose_conformances(decl):
                decl.conformances.extend(conformances)

            if not isinstance(decl, SwiftExtensionDecl):
                continue
            if not isinstance(decl.original_node, c_ast.Struct):
                continue

            for conformance in sorted(decl.conformances):
                if gen := get_conformance_generator(conformance):
                    decl.members.extend(
                        gen.generate_members(decl, decl.original_node)
                    )

        return result


class Z3SymbolFilter(SymbolGeneratorFilter):
    def should_gen_enum_extension(
        self, node: c_ast.Enum, decl: SwiftExtensionDecl
    ) -> bool:
        return super().should_gen_enum_extension(node, decl)

    def should_gen_enum_var_member(
        self, node: c_ast.Enumerator, decl: SwiftMemberVarDecl
    ) -> bool:
        return super().should_gen_enum_var_member(node, decl)


class Z3NameGenerator(SymbolNameGenerator):
    formatter: SymbolNameFormatter

    def __init__(self):
        self.formatter = DefaultSymbolNameFormatter(
            words_to_split=[
                re.compile(r"(l)(bool)$", flags=re.IGNORECASE)
            ],
        )

    def format_enum_case_name(self, name: CompoundSymbolName) -> CompoundSymbolName:
        """
        Fixes some wonky enum case name capitalizations.
        """
        name = self.formatter.format(name)
        result: list[CompoundSymbolName.Component] = name.components

        for i, comp in enumerate(result):
            if comp.string.startswith("Uint"):
                result[i] = comp.replacing_in_string("Uint", "UInt").with_string_case(
                    ComponentCase.AS_IS
                )

        return CompoundSymbolName(result)

    def generate(self, name: str) -> CompoundSymbolName:
        return CompoundSymbolName.from_snake_case(name)

    def generate_struct_name(self, name: str) -> CompoundSymbolName:
        return self.formatter.format(self.generate(name)).pascal_cased()

    def generate_enum_name(self, name: str) -> CompoundSymbolName:
        return self.formatter.format(self.generate(name)).pascal_cased()

    def generate_enum_case(
        self, enum_name: CompoundSymbolName, enum_original_name: str, case_name: str
    ) -> CompoundSymbolName:
        name = CompoundSymbolName.from_snake_case(case_name)

        orig_enum_name = CompoundSymbolName.from_snake_case(enum_original_name)

        (new_name, prefix) = name.removing_common(orig_enum_name, case_sensitive=False)
        new_name = new_name.camel_cased()

        if prefix is not None:
            prefix = prefix.camel_cased()
            new_name[0].joint_to_prev = "_"

            new_name = CompoundSymbolName(
                components=prefix.components + new_name.components
            )

        return self.format_enum_case_name(new_name)

    def generate_original_enum_name(self, name: str) -> CompoundSymbolName:
        return self.generate(name)

    def generate_original_enum_case(self, case_name: str) -> CompoundSymbolName:
        return self.generate(case_name)

    def generate_original_struct_name(self, name: str) -> CompoundSymbolName:
        return self.generate(name)

class Z3DoccommentLookup(DoccommentLookup):
    def populate_doc_comments(self, decls: Sequence[SwiftDecl]) -> list[SwiftDecl]:
        result = super().populate_doc_comments(decls)

        # Extract markdown bullet-point style lists from parent descriptions into
        # child declarations
        for decl in result:
            if not isinstance(decl, SwiftExtensionDecl):
                continue
            if decl.doccomment is None:
                continue

            picker = DoccommentListPicker(decl.doccomment)
            
            for member in decl.members:
                c_name = member.original_name.to_string()
                if doc := picker.pick(c_name):
                    member.doccomment = DoccommentBlock.merge(
                        member.doccomment,
                        doc
                    )

            decl.doccomment = picker.result_comment()

        return result

class Z3DoccommentFormatter(DoccommentFormatter):
    """
    Formats doc comments from Z3 to be more Swifty, including renaming \
    referenced C symbol names to the converted Swift names.
    """

    def __init__(self):
        self.remove_regex = re.compile(r"\\(brief|ingroup)", re.IGNORECASE)
        self.ref_regex = re.compile(r"\\(?:ref|c) (\w+(?:\(\))?)", re.IGNORECASE)
        self.backtick_regex = re.compile(r"`([^`]+)`")
        self.backtick_word_regex = re.compile(r"\w+")
        self.backtick_cpp_member_regex = re.compile(r"(\w+)::(\w+)")

    def replace_refs(self, comment: str) -> str:
        return self.ref_regex.sub(
            lambda match: f"`{''.join(match.groups())}`",
            comment
        )

    def convert_refs(self, comment: str, lookup: SwiftDeclLookup) -> str:
        def convert_word_match(match: re.Match[str]) -> str:
            name = match.group()
            swift_name = lookup.lookup_c_symbol(name)
            if swift_name is not None:
                return swift_name

            return name

        def convert_backtick_match(match: re.Match[str]) -> str:
            replaced = self.backtick_word_regex.sub(
                convert_word_match,
                match.group(),
            )
            # Perform C++ symbol rewriting (Type::member)
            replaced = self.backtick_cpp_member_regex.sub(
                lambda m: f"{m.group(1)}.{m.group(2)}",
                replaced
            )
            
            return replaced

        return self.backtick_regex.sub(convert_backtick_match, comment)

    def format_doccomment(
        self, comment: DoccommentBlock | None, decl: SwiftDecl, lookup: SwiftDeclLookup
    ) -> DoccommentBlock | None:
        if comment is None:
            return None
        
        new_comments = comment.comment_contents
        
        # Remove '\ingroup*', '\brief*', and other Doxygen-specific tags
        new_comments = self.remove_regex.sub("", new_comments)

        # Reword '\note' to '- note'
        new_comments = new_comments.replace("\\note", "- note:")

        # Replace "\ref <symbol>" or "\c <symbol>" with "`<symbol>`"
        new_comments = self.replace_refs(new_comments)

        # Convert C symbol references to Swift symbols
        new_comments = self.convert_refs(new_comments, lookup)

        return super().format_doccomment(comment.with_contents(new_comments), decl, lookup)


class Z3DirectoryStructureManager(DirectoryStructureManager):
    def file_name_for_decl(self, decl: SwiftDecl) -> str:
        # For struct conformances, append a "+Ext.swift" to the suffix of the
        # filename
        if decl.c_kind == CDeclKind.STRUCT and isinstance(decl, SwiftExtensionDecl) and len(decl.conformances) > 0:
            return f"{decl.name.to_string()}+Ext.swift"

        return super().file_name_for_decl(decl)

    def make_declaration_files(self, decls: Iterable[SwiftDecl]) -> list[SwiftFile]:
        result = super().make_declaration_files(decls)
        for file in result:
            file.header_lines.append(
                f"// Generated by {Path(__file__).relative_to(paths.SOURCE_ROOT_PATH)}"
            )

        return result

    def path_matchers(self) -> list[DirectoryStructureEntry]:
        # Array of tuples containing:
        # tuple.0: An array of path components (min 1, must not have special characters);
        # tuple.1: Either a regular expression, OR a list of regular expression/exact
        #          strings that file names will be tested against.
        # Matches are made against full file names, with no directory information,
        # e.g.: "BLContext.swift", "BLFillRule.swift", "BLResultCode.swift", etc.
        return [
            
        ]


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generates .swift files for Z3 enum and struct declarations."
    )

    parser.add_argument(
        "--stdout",
        action="store_true",
        help="Outputs files to stdout instead of file disk.",
    )
    parser.add_argument(
        "-o",
        "--output",
        dest="path",
        type=Path,
        help="Path to put generated files on",
    )

    args = parser.parse_args()

    input_path = paths.scripts_path(FILE_NAME)
    if not input_path.exists() or not input_path.is_file():
        print("Error: Expected path to an existing header file within utils\\.")
        return 1

    swift_target_path = (
        args.path
        if args.path is not None
        else paths.srcroot_path("Sources", "SwiftZ3", "Generated")
    )
    if not swift_target_path.exists() or not swift_target_path.is_dir():
        print(f"Error: No target directory with name '{swift_target_path}' found.")
        return 1

    destination_path = swift_target_path

    target: DeclGeneratorTarget

    if args.stdout:
        target = DeclFileGeneratorStdoutTarget()
    else:
        target = DeclFileGeneratorDiskTarget(destination_path, rm_folder=True)

    symbol_filter = Z3SymbolFilter()
    symbol_name_generator = Z3NameGenerator()
    request = TypeGeneratorRequest(
        header_file=input_path,
        destination=destination_path,
        prefixes=Z3_PREFIXES,
        target=target,
        includes=["CZ3"],
        swift_decl_generator=Z3DeclGenerator(
            prefixes=Z3_PREFIXES,
            symbol_filter=symbol_filter,
            symbol_name_generator=symbol_name_generator,
        ),
        symbol_filter=symbol_filter,
        symbol_name_generator=symbol_name_generator,
        doccomment_lookup=Z3DoccommentLookup(),
        doccomment_formatter=Z3DoccommentFormatter(),
        directory_manager=Z3DirectoryStructureManager(destination_path),
    )

    generate_types(request)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(1)
