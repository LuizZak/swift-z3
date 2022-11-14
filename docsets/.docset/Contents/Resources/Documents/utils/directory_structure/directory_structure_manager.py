import re
from pathlib import Path
from typing import List, Iterable

from utils.data.swift_decls import SwiftDecl
from utils.data.swift_file import SwiftFile

DirectoryStructureEntry = tuple[list[str], str | re.Pattern | list[str | re.Pattern]]


class DirectoryStructureManager:
    """
    A class that is used to manage nested directory structures for generated types.
    """

    def __init__(self, base_path: Path):
        self.base_path = base_path

    def path_matchers(self) -> list[DirectoryStructureEntry]:
        return list()

    def make_declaration_files(self, decls: Iterable[SwiftDecl]) -> list[SwiftFile]:
        result: dict[Path, SwiftFile] = dict()

        for decl in decls:
            path = self.path_for_decl(decl)
            file = result.get(path, SwiftFile(path, [], []))
            file.add_decl(decl)

            result[path] = file

        return list(result.values())

    def path_for_decl(self, decl: SwiftDecl) -> Path:
        file_path = self.file_for_decl(decl)

        return file_path

    def folder_for_file(self, file_name: str) -> Path:
        def matches(
            pattern: str | re.Pattern | list[str | re.Pattern],
            file_name: str,
        ) -> bool:
            if isinstance(pattern, re.Pattern):
                if not pattern.match(file_name):
                    return False

                return True

            for pat in pattern:
                if isinstance(pat, str):
                    if pat == file_name:
                        return True
                    else:
                        continue
                if isinstance(pat, list):
                    return True if file_name in pat else False
                elif pat.match(file_name):
                    return True

            return False

        dir_path = self.base_path
        longest_path: List[str] = []

        for (path, pat) in self.path_matchers():
            if not matches(pat, file_name):
                continue

            if len(path) > len(longest_path):
                longest_path = path

        for component in longest_path:
            if not component.isalnum():
                raise Exception(
                    f"Expected suggested paths to contain only alphanumeric values for file {file_name}, found {component} (full: {longest_path})"
                )

        return dir_path.joinpath(*longest_path)

    def file_for_decl(self, decl: SwiftDecl) -> Path:
        file_name = self.file_name_for_decl(decl)

        return self.folder_for_file(file_name).joinpath(file_name)

    def file_name_for_decl(self, decl: SwiftDecl) -> str:
        return f"{decl.name.to_string()}.swift"
