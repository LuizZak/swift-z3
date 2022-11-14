from dataclasses import dataclass, field
from pathlib import Path

from utils.converters.syntax_stream import SyntaxStream
from utils.data.swift_decls import SwiftDecl


@dataclass
class SwiftFile:
    """Represents a Swift file and its declarations."""

    path: Path
    decls: list[SwiftDecl]
    includes: list[str]
    header_lines: list[str] = field(
        default_factory=lambda: [
            "// HEADS UP!: Auto-generated file, changes made directly here will be overwritten by code generators."
        ]
    )
    "List of lines to prefix the file with"

    def add_decl(self, decl: SwiftDecl):
        self.decls.append(decl)

    def write(self, stream: SyntaxStream):
        # Write required boilerplate
        for line in self.header_lines:
            stream.line(line)

        if len(self.includes) > 0:
            stream.line()
            for include in self.includes:
                stream.line(f"import {include}")

        for decl in self.decls:
            stream.line()
            decl.write(stream)
