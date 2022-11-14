import itertools

from typing import TypeVar, Iterable

T = TypeVar("T")


def flatten(array: Iterable[Iterable[T]]) -> list[T]:
    return list(itertools.chain.from_iterable(array))
