# Utility to extract Swift-styled aliases of DirectX C types.

import sys
import os
import subprocess
import shutil
from dataclasses import dataclass
from typing import Generator

import pycparser

from pathlib import Path
from pycparser import c_ast
from contextlib import contextmanager
from utils.cli.cli_printing import print_stage_name
from utils.cli.console_color import ConsoleColor

from utils.converters.syntax_stream import SyntaxStream
from utils.data.swift_decl_lookup import SwiftDeclLookup
from utils.data.swift_decl_visitor import SwiftDeclVisitor
from utils.doccomment.doccomment_block import DoccommentBlock
from utils.doccomment.doccomment_formatter import DoccommentFormatter
from utils.generator.swift_decl_generator import SwiftDeclGenerator
from utils.generator.symbol_generator_filter import SymbolGeneratorFilter
from utils.generator.symbol_name_generator import SymbolNameGenerator
from utils.data.swift_decls import (
    SwiftDecl,
    SwiftDeclWalker,
    SwiftDeclVisitResult,
    SwiftExtensionDecl,
)
from utils.directory_structure.directory_structure_manager import (
    DirectoryStructureManager,
)
from utils.data.swift_file import SwiftFile
from utils.doccomment.doccomment_lookup import DoccommentLookup

# Utils
from utils.paths import paths


def run_cl(input_path: Path) -> bytes:
    args: list[str | os.PathLike] = [
        "cl",
        "/E",
        "/Za",
        "/Zc:wchar_t",
        input_path,
    ]

    return subprocess.check_output(args, cwd=paths.SCRIPTS_ROOT_PATH)


def run_clang(input_path: Path) -> bytes:
    args: list[str | os.PathLike] = [
        "clang",
        "-E",
        "-fuse-line-directives",
        "-std=c99",
        "-pedantic-errors",
        input_path,
    ]

    return subprocess.check_output(args, cwd=paths.SCRIPTS_ROOT_PATH)


def run_c_preprocessor(input_path: Path) -> bytes:
    if sys.platform == "win32":
        return run_cl(input_path)

    return run_clang(input_path)


class SwiftDeclMerger:
    """
    Merges Swift declarations that share a name
    """

    def merge(self, decls: list[SwiftDecl]) -> list[SwiftDecl]:
        decl_dict: dict[str, SwiftDecl] = dict()

        for decl in decls:
            decl_name = decl.name.to_string()
            existing = decl_dict.get(decl_name)
            if existing is not None:
                if ext_decl := self.try_merge_as_extensions(existing, decl):
                    decl_dict[decl_name] = ext_decl
                    continue

                existing_name = existing.name.to_string()
                existing_original = existing.original_name.to_string() if existing.original_name is not None else "<none>"
                decl_original = decl.original_name.to_string() if decl.original_name is not None else "<none>"

                raise BaseException(
                    f"Found two symbols that share the same name but are of different types: {existing_name} (type: {type(existing)}) (originally: {existing_original}) and {decl_name} (type: {type(decl)}) (originally: {decl_original})"
                )

            else:
                decl_dict[decl_name] = decl

        return list(decl_dict.values())

    def try_merge_as_extensions(
        self, decl1: SwiftDecl, decl2: SwiftDecl
    ) -> SwiftExtensionDecl | None:

        if isinstance(decl1, SwiftExtensionDecl) and isinstance(
            decl2, SwiftExtensionDecl
        ):
            node = self.choose_nodes(decl1.original_node, decl2.original_node)
            
            return SwiftExtensionDecl(
                name=decl1.name,
                original_name=decl1.original_name,
                members=decl1.members + decl2.members,
                origin=decl1.origin,
                original_node=node,
                c_kind=decl1.c_kind,
                doccomment=DoccommentBlock.merge(decl1.doccomment, decl2.doccomment),
                conformances=list(set(decl1.conformances + decl2.conformances)),
            )

        return None
    
    def choose_nodes(self, node1: c_ast.Node | None, node2: c_ast.Node | None) -> c_ast.Node | None:
        if node1 is None:
            return node2
        if node2 is None:
            return node1
        
        # Choose the source node that has members, if possible
        match (node1, node2):
            case (c_ast.Struct(), c_ast.Struct()):
                if node1.decls is None:
                    return node2
                if node2.decls is None:
                    return node1
        
        return node1


class DeclGeneratorTarget:
    def prepare(self):
        pass

    @contextmanager
    def create_stream(self, _: Path) -> Generator:
        raise NotImplementedError("Must be overridden by subclasses.")


class DeclFileGeneratorDiskTarget(DeclGeneratorTarget):
    def __init__(
        self, destination_folder: Path, rm_folder: bool = True, verbose: bool = True
    ):
        self.destination_folder = destination_folder
        self.rm_folder = rm_folder
        self.directory_manager = DirectoryStructureManager(destination_folder)
        self.verbose = verbose

    def prepare(self):
        if self.verbose:
            print(
                f"Generating .swift files to {ConsoleColor.MAGENTA(self.destination_folder)}..."
            )

        if self.rm_folder:
            shutil.rmtree(self.destination_folder)
            os.mkdir(self.destination_folder)

    @contextmanager
    def create_stream(self, path: Path) -> Generator:
        path.parent.mkdir(parents=True, exist_ok=True)

        with open(path, "w", newline="\n") as file:
            stream = SyntaxStream(file)
            yield stream


class DeclFileGeneratorStdoutTarget(DeclGeneratorTarget):
    @contextmanager
    def create_stream(self, path: Path) -> Generator:
        stream = SyntaxStream(sys.stdout)
        yield stream


class DeclFileGenerator:
    def __init__(
        self,
        destination_folder: Path,
        target: DeclGeneratorTarget,
        decls: list[SwiftDecl],
        includes: list[str],
        directory_manager: DirectoryStructureManager | None = None,
        verbose: bool = False,
    ):
        if directory_manager is None:
            self.directory_manager = DirectoryStructureManager(destination_folder)
        else:
            self.directory_manager = directory_manager

        self.destination_folder = destination_folder
        self.target = target
        self.decls = decls
        self.includes = includes
        self.verbose = verbose

    def generate_file(self, file: SwiftFile):
        with self.target.create_stream(file.path) as stream:
            file.write(stream)

    def generate(self):
        self.target.prepare()

        files = self.directory_manager.make_declaration_files(self.decls)

        for file in files:
            file.includes = self.includes
            self.generate_file(file)

            if self.verbose:
                rel_path = file.path.relative_to(self.destination_folder)
                print(
                    f"Generated {ConsoleColor.MAGENTA(rel_path)} with {ConsoleColor.CYAN(len(file.decls))} declaration(s)"
                )


# noinspection PyPep8Naming
class DeclCollectorVisitor(c_ast.NodeVisitor):
    decls: list[c_ast.Node] = []

    def __init__(self, prefixes: list[str]):
        self.prefixes = prefixes

    def should_include(self, decl_name: str) -> bool:
        for prefix in self.prefixes:
            if decl_name.startswith(prefix):
                return True

        return False
    
    def visit_Typedef(self, node: c_ast.Typedef):
        if node.name is not None and self.should_include(node.name):
            self.decls.append(node)

    def visit_Struct(self, node: c_ast.Struct):
        if node.name is not None and self.should_include(node.name):
            self.decls.append(node)

    def visit_Enum(self, node: c_ast.Enum):
        if node.name is not None and self.should_include(node.name):
            self.decls.append(node)


class SwiftDoccommentFormatterVisitor(SwiftDeclVisitor):
    def __init__(self, formatter: DoccommentFormatter, lookup: SwiftDeclLookup):
        self.formatter = formatter
        self.lookup = lookup

    def generic_visit(self, decl: SwiftDecl) -> SwiftDeclVisitResult:
        decl.doccomment = self.formatter.format_doccomment(
            decl.doccomment, decl, self.lookup
        )

        return SwiftDeclVisitResult.VISIT_CHILDREN


@dataclass
class TypeGeneratorRequest:
    header_file: Path
    destination: Path
    prefixes: list[str]
    target: DeclGeneratorTarget
    includes: list[str]
    swift_decl_generator: SwiftDeclGenerator | None
    symbol_filter: SymbolGeneratorFilter
    symbol_name_generator: SymbolNameGenerator
    doccomment_lookup: DoccommentLookup | None
    doccomment_formatter: DoccommentFormatter | None
    directory_manager: DirectoryStructureManager | None


def generate_types(request: TypeGeneratorRequest) -> int:
    print_stage_name("Generating header file...")

    output_file = run_c_preprocessor(request.header_file)

    # Windows-specific fix to replace some page feeds that are present in the original system headers
    if sys.platform == "win32":
        output_file = output_file.replace(b"\x0c", b"")

    output_path = request.header_file.with_suffix(".i")
    with open(output_path, "wb") as f:
        f.write(output_file)

    print_stage_name("Parsing generated header file...")

    ast = pycparser.parse_file(output_path, use_cpp=False)

    print_stage_name("Collecting Swift type candidates...")

    visitor = DeclCollectorVisitor(prefixes=request.prefixes)
    visitor.visit(ast)

    if request.swift_decl_generator is not None:
        converter = request.swift_decl_generator
    else:
        converter = SwiftDeclGenerator(
            prefixes=request.prefixes,
            symbol_filter=request.symbol_filter,
            symbol_name_generator=request.symbol_name_generator,
        )

    swift_decls = converter.generate_from_list(visitor.decls)

    print(f"Found {ConsoleColor.CYAN(len(swift_decls))} potential declarations")

    print_stage_name("Generating doc comments...")

    doccomment_lookup = request.doccomment_lookup if request.doccomment_lookup is not None else DoccommentLookup()
    swift_decls = doccomment_lookup.populate_doc_comments(swift_decls)

    print_stage_name("Merging generated Swift type declarations...")

    merger = SwiftDeclMerger()
    swift_decls = merger.merge(swift_decls)

    print(f"Merged down to {ConsoleColor.CYAN(len(swift_decls))} declarations")

    swift_decls = converter.post_merge(swift_decls)

    if request.doccomment_formatter is not None:
        print_stage_name("Formatting doc comments...")

        lookup = SwiftDeclLookup(swift_decls)
        doc_visitor = SwiftDoccommentFormatterVisitor(
            request.doccomment_formatter, lookup
        )
        walker = SwiftDeclWalker(doc_visitor)

        for decl in swift_decls:
            walker.walk_decl(decl)

    print_stage_name("Generating files...")

    generator = DeclFileGenerator(
        request.destination,
        request.target,
        swift_decls,
        request.includes,
        request.directory_manager,
        verbose=True,
    )
    generator.generate()

    print(ConsoleColor.GREEN("Success!"))

    return 0
