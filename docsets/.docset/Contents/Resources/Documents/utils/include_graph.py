# Generates a .dot Graphviz file with the include graph starting from a given header file.

import argparse
import subprocess
import sys
import re
import graphlib

from collections import defaultdict
from dataclasses import dataclass
from io import StringIO
from pathlib import Path
from typing import List, Generic, TypeVar


def make_argparser() -> argparse.ArgumentParser:
    argparser = argparse.ArgumentParser(
        description="Generates a .dot Graphviz file with the include graph starting from a given header file. Results "
        "gets printed to stdout. "
    )
    argparser.add_argument(
        "header_file_path",
        type=Path,
        help="Initial header file to start inspection from.",
    )

    return argparser


def run_cl(header_file_path: Path) -> str:
    args = ["cl", "/showIncludes", str(header_file_path), "/E"]

    proc = subprocess.run(args, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
    proc.check_returncode()

    return proc.stderr.decode("UTF8")


# https://stackoverflow.com/a/30747003
T = TypeVar("T")


class Graph(Generic[T]):
    """Graph data structure, directed by default."""

    def __init__(self, connections=None, directed=True):
        if connections is None:
            connections = []

        self._graph = defaultdict(set)
        self._directed = directed
        self.add_connections(connections)

    def topological_sort(self) -> list[T]:
        return list(graphlib.TopologicalSorter(self._graph).static_order())

    def add_connections(self, connections):
        """Add connections (list of tuple pairs) to graph"""

        for node1, node2 in connections:
            self.add(node1, node2)

    def add(self, node1, node2):
        """Add connection between node1 and node2"""

        self._graph[node1].add(node2)
        if not self._directed:
            self._graph[node2].add(node1)

    def remove(self, node):
        """Remove all references to node"""

        for n, cxns in self._graph.items():  # python3: items(); python2: iteritems()
            try:
                cxns.remove(node)
            except KeyError:
                pass
        try:
            del self._graph[node]
        except KeyError:
            pass

    def is_connected(self, node1, node2):
        """Is node1 directly connected to node2"""

        return node1 in self._graph and node2 in self._graph[node1]

    def find_path(self, node1, node2, path=None):
        """Find any path between node1 and node2 (may not be shortest)"""

        if path is None:
            path = []

        path = path + [node1]
        if node1 == node2:
            return path
        if node1 not in self._graph:
            return None
        for node in self._graph[node1]:
            if node not in path:
                new_path = self.find_path(node, node2, path)
                if new_path:
                    return new_path
        return None

    def __str__(self):
        return "{}({})".format(self.__class__.__name__, dict(self._graph))


@dataclass
class HeaderFile(object):
    path: Path

    def __hash__(self) -> int:
        return self.path.__hash__()


class Buffer(object):
    """Simple string buffer class"""

    def __init__(self):
        self._buffer = StringIO()
        self._indent = 0

    def line(self, s: str = ""):
        self._buffer.write(f"{self._indent_string()}{s}\n")
        return self

    def indent(self):
        self._indent += 1
        return self

    def unindent(self):
        self._indent -= 1
        return self

    def _indent_string(self) -> str:
        return "    " * self._indent

    def string(self) -> str:
        return self._buffer.getvalue()


class HeaderPrinter(object):
    def __init__(self, headers: List[HeaderFile]):
        self.headers = headers
        # If more than one header has the same file-name, but different
        # paths, use hash of full file paths as identifiers for the nodes.
        self.use_hash = len(set(map(lambda h: h.path.name, headers))) != len(headers)

    def label(self, header: HeaderFile) -> str:
        return header.path.name

    def id(self, header: HeaderFile) -> str:
        if self.use_hash:
            return f"n{hash(header.path)}".replace("-", "_")
        else:
            return f'"{self.label(header)}"'

    def node_def(self, header: HeaderFile) -> str:
        if self.use_hash:
            return f'{self.id(header)} [label="{self.label(header)}"]'
        else:
            return self.id(header)


def print_graphviz(graph: Graph[HeaderFile]) -> str:
    nodes = graph.topological_sort()
    nodes = list(reversed(nodes))

    printer = HeaderPrinter(nodes)

    result = Buffer()
    result.line("digraph G {").indent()
    result.line('graph [rankdir="LR"]').line()

    result.line("# Node definitions")
    for item in nodes:
        result.line(printer.node_def(item))

    result.line()
    result.line("# Node connections")
    for item1 in nodes:
        for item2 in nodes:
            if graph.is_connected(item1, item2):
                result.line(f"{printer.id(item1)} -> {printer.id(item2)}")

    result.unindent()
    result.line("}")

    return result.string()


def process(header_file_path: Path, output: str) -> str:
    pattern = re.compile(r"Note: including file:(\s+)(.+)")

    depth = 0
    start = HeaderFile(header_file_path)
    stack = [start]

    graph = Graph[HeaderFile]()

    def is_in_stack(h: HeaderFile) -> bool:
        for item in stack:
            if item.path.samefile(h.path):
                return True

        return False

    for line in output.splitlines():
        match = pattern.match(line)
        if match is None:
            continue

        header = HeaderFile(Path(match.group(2)))

        new_depth = len(match.group(1))

        if new_depth == depth:
            if not is_in_stack(header):
                graph.add(stack[-2], header)

            stack[-1] = header

        if new_depth > depth:
            if not is_in_stack(header):
                top = stack[-1]
                graph.add(top, header)

            stack.append(header)

        if new_depth < depth:
            stack = stack[:new_depth]

            if not is_in_stack(header):
                top = stack[-1]
                graph.add(top, header)

            stack.append(header)

        depth = new_depth

    return print_graphviz(graph)


def main() -> int:
    parser = make_argparser()
    args = parser.parse_args()

    header_file_path: Path = args.header_file_path

    output = run_cl(header_file_path)

    print(process(header_file_path, output))

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(1)
