from typing import TextIO
from contextlib import contextmanager


class SyntaxStream:
    def __init__(self, destination: TextIO):
        self.destination = destination
        self.indent_depth = 0

    def write(self, text: str):
        self.destination.write(text)

    def write_then_line(self, text: str = ""):
        "Writes a given string of text and output a line break at the end."
        self.write(f"{text}\n")

    def indent_str(self) -> str:
        return "    " * self.indent_depth

    def line(self, text: str = ""):
        self.pre_line()
        self.write_then_line(text)

    def pre_line(self):
        "Prints the indentation for a line"
        self.write(f"{self.indent_str()}")

    def indent(self):
        self.indent_depth += 1

    def unindent(self):
        self.indent_depth -= 1

    @contextmanager
    def block(self, line: str):
        self.line(line)
        self.indent()

        yield

        self.unindent()
        self.line("}")

    @contextmanager
    def inline_block(self, line: str, close_brace: str = "}"):
        self.write_then_line(line)
        self.indent()

        yield

        self.unindent()
        self.line(close_brace)
