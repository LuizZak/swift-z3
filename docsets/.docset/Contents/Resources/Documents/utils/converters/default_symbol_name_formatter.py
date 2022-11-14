import re

from typing import Tuple

from utils.collection.collection_utils import flatten
from utils.converters.base_word_capitalizer import BaseWordCapitalizer
from utils.converters.symbol_name_formatter import SymbolNameFormatter
from utils.data.compound_symbol_name import CompoundSymbolName
from utils.data.compound_symbol_name import ComponentCase


class DefaultSymbolNameFormatter(SymbolNameFormatter):
    capitalizers: list[BaseWordCapitalizer]
    """
    Capitalizers for words that are contained within terms.
    When capitalizers report a substring to capitalize, the string is split and the substring
    portion pinned to uppercase.

    - note: Capitalization implicitly splits components in a CompoundSymbolName into separate
    components.
    - note: If more than one entry in this list match a single component, the entry that
    matches earliest in the string is chosen.
    """

    # TODO: Figure out a better way to automatically recognize joined symbol name.
    words_to_split: list[re.Pattern]
    """
    Use multi-word regex when a standalone word might lead to unintended matches in compound words.
    eg: D2D1_COLORMANAGEMENT_PROP
    would be an entry like:
    `re.compile(r"(Color)(Management)", flags=re.IGNORECASE)`

    - NOTE: Regex are applied recursively to split segments, so simple regex that have a single capture group will lead to recursion errors.
    """

    terms_to_snake_case_after: list[str]
    """
    List of camelCase terms to detect and split into a trailing snake_case.

    E.g.: To split 'x86Sse2' into x86_sse2, provide `terms_to_snake_case=["x86"]`.

    - note: Matching is case-sensitive.
    """

    def __init__(
        self,
        capitalizers: list[BaseWordCapitalizer] = None,
        words_to_split: list[re.Pattern] | None = None,
        terms_to_snake_case_after: list[str] | None = None,
    ):
        if capitalizers is None:
            capitalizers = []
        if words_to_split is None:
            words_to_split = []
        if terms_to_snake_case_after is None:
            terms_to_snake_case_after = []

        self.capitalizers = capitalizers
        self.words_to_split = words_to_split
        self.terms_to_snake_case_after = terms_to_snake_case_after

    def format(self, name: CompoundSymbolName) -> CompoundSymbolName:
        # Split/capitalize
        components = flatten(map(self.split_and_capitalize, name.components))

        if len(name.components) > 0:
            is_camel_case = name.components[0].to_string(False)[0].islower()

            if is_camel_case and len(components) > 0:
                components[0] = components[0].with_string_case(ComponentCase.LOWER)

        # Snakecase
        components = self.snake_case(components)

        return CompoundSymbolName(components)

    def split_and_capitalize(
        self, component: CompoundSymbolName.Component
    ) -> list[CompoundSymbolName.Component]:
        # Split component
        split_string: list[str] = []
        self.split_component_inplace(component.string, split_string)

        # Capitalize
        split_components_str = flatten(
            map(
                lambda p: self.capitalize_component_string(p[1], has_prev=p[0] > 0),
                enumerate(split_string),
            )
        )

        # Rejoin
        split_components = list(
            map(
                lambda t: component.with_string(t[0]).with_string_case(
                    component.string_case | t[1]
                ),
                split_components_str,
            )
        )

        return split_components

    def split_component_inplace(self, string: str, output: list[str]):
        for pattern in self.words_to_split:
            if pattern.search(string):
                filtered = list(
                    filter(
                        lambda x: x is not None and len(x) > 0, pattern.split(string)
                    )
                )

                if len(filtered) == 1 and filtered[0] == string:
                    break

                for word in filtered:
                    self.split_component_inplace(word, output)

                return

        output.append(string)

    def split_component_string(self, string: str) -> list[str]:
        for pattern in self.words_to_split:
            if pattern.match(string):
                filtered = filter(lambda x: len(x) > 0, pattern.split(string))

                return list(filtered)

        return [string]

    def capitalize_component_string(
        self, string: str, has_prev: bool
    ) -> list[Tuple[str, ComponentCase]]:

        result: list[Tuple[str, ComponentCase]] = []
        leftmost_interval: Tuple[str, int, int] | None = None

        for capitalizer in self.capitalizers:
            cap_result = capitalizer.suggest_capitalization(
                string, has_leading_string=has_prev
            )
            if cap_result is None:
                continue

            if leftmost_interval is None or cap_result[1] < leftmost_interval[1]:
                leftmost_interval = cap_result

        if leftmost_interval is None:
            if has_prev:
                string = string[0].upper() + string[1:]

            return [(string, ComponentCase.ANY)]

        if leftmost_interval[1] > 0:
            result.extend(
                self.capitalize_component_string(
                    string[0 : leftmost_interval[1]], has_prev=has_prev
                )
            )

        result.append((leftmost_interval[0], ComponentCase.AS_IS))

        if leftmost_interval[2] < len(string) - 1:
            result.extend(
                self.capitalize_component_string(
                    string[leftmost_interval[2] :], has_prev=True
                )
            )

        return result

    def snake_case(
        self, components: list[CompoundSymbolName.Component]
    ) -> list[CompoundSymbolName.Component]:

        result = []
        snake_case_next = False

        for comp in components:
            if snake_case_next:
                comp = comp.with_joint_to_prev("_").lower()
                snake_case_next = False

            for term in self.terms_to_snake_case_after:
                if comp.string == term:
                    snake_case_next = True
                    break

            result.append(comp)

        return result
