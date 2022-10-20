from os import PathLike
from pathlib import Path

SOURCE_ROOT_PATH = Path(__file__).parents[2]
SCRIPTS_ROOT_PATH = Path(__file__).parents[1]


def path(root: Path | str, *args: str | PathLike[str]) -> Path:
    return Path(root).joinpath(*args)


def srcroot_path(*args: str | PathLike[str]) -> Path:
    return path(SOURCE_ROOT_PATH, *args)


def scripts_path(*args: str | PathLike[str]) -> Path:
    return path(SCRIPTS_ROOT_PATH, *args)
