import re
from collections.abc import Sequence
from dataclasses import dataclass
from typing import Callable, Hashable, Iterator, Optional, Tuple

from enum import Enum


class ComponentCase(Enum):
    """
    Describes the casing for a CompoundSymbolName.Component.
    """
    ANY = 0
    "Any casing is supported."

    AS_IS = 1
    "Component's casing must be maintained as-is during transformations."

    UPPER = 2
    "Component is pinned to UPPERCASE."

    LOWER = 3
    "Component is pinned to lowercase."

    CAPITALIZED = 4
    "Component is pinned to Capitalized."

    def change_case(self, string: str) -> str:
        """
        Changes a string to a case matching the one specified by 'self'. If the casing is ANY or AS_IS,
        the string is returned as-is.

        >>> ComponentCase.ANY.change_case("AString")
        'AString'
        >>> ComponentCase.UPPER.change_case("AString")
        'ASTRING'
        >>> ComponentCase.LOWER.change_case("AString")
        'astring'
        >>> ComponentCase.CAPITALIZED.change_case("AString")
        'Astring'
        >>> ComponentCase.AS_IS.change_case("AString")
        'AString'
        """
        match self:
            case ComponentCase.ANY:
                return string
            case ComponentCase.AS_IS:
                return string
            case ComponentCase.UPPER:
                return string.upper()
            case ComponentCase.LOWER:
                return string.lower()
            case ComponentCase.CAPITALIZED:
                return string.capitalize()

    def __or__(self, other):
        """
        Returns `other` if `self` is `ComponentCase.ANY`, `self` otherwise.

        >>> ComponentCase.ANY | ComponentCase.ANY
        <ComponentCase.ANY: 0>
        >>> ComponentCase.ANY | ComponentCase.AS_IS
        <ComponentCase.AS_IS: 1>
        >>> ComponentCase.UPPER | ComponentCase.LOWER
        <ComponentCase.UPPER: 2>
        """
        if self == ComponentCase.ANY:
            return other

        return self


_pascal_case_matcher = re.compile(r'.+?(?:(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])|$)')

@dataclass(repr=False)
class CompoundSymbolName(Sequence, Hashable):
    """
    A type that is used to describe a symbol name as a collection of words
    that are stitched together as a string to produce a final identifier name.

    Can be used for camelCase, PascalCase, and snake_case strings.
    """

    @dataclass(repr=False)
    class Component(Hashable):
        """
        A component of a CompoundSymbolName.
        """

        string: str
        "The string of this component"

        prefix: Optional[str] = None
        "An optional prefix that is prepended to this component when producing full strings."

        suffix: Optional[str] = None
        "An optional suffix that is appended to this component when producing full strings."

        joint_to_prev: Optional[str] = None
        "A string that is appended to this component if it follows another component in a symbol name."

        string_case: ComponentCase = ComponentCase.ANY
        "Specifies the suggested casing for this component."

        def __repr__(self) -> str:
            return f"CompoundSymbolName.Component(string={self.string}, prefix={self.prefix}, prefix={self.suffix}, " \
                   f"prefix={self.joint_to_prev}, string_case={self.string_case})"
        
        def __key(self):
            return (self.string, self.prefix, self.suffix, self.joint_to_prev, self.string_case)

        def __hash__(self) -> int:
            return hash(self.__key())
        
        def __eq__(self, other: object) -> bool:
            if isinstance(other, CompoundSymbolName.Component):
                return self.__key() == other.__key()
            
            return False

        def copy(self) -> "CompoundSymbolName.Component":
            """
            Returns an exact copy of this Component.

            >>> CompoundSymbolName.Component(string="string", prefix="prefix",
            ...                              suffix="suffix", joint_to_prev="_",
            ...                              string_case=ComponentCase.LOWER).copy()
            CompoundSymbolName.Component(string=string, prefix=prefix, prefix=suffix, prefix=_, string_case=ComponentCase.LOWER)
            """
            return CompoundSymbolName.Component(
                self.string, self.prefix, self.suffix, self.joint_to_prev, self.string_case
            )

        def with_string_only(self, string_case: ComponentCase | None = None) -> "CompoundSymbolName.Component":
            """
            Returns a copy of this component with the same self.string, but nil prefix, suffix, and joint_to_prev.

            If string_case is specified, string_case of the return is assigned that value, otherwise keeps the case
            of the current instance.
            """
            if string_case is None:
                string_case = self.string_case

            return CompoundSymbolName.Component(self.string, string_case=string_case)

        def with_prefix(self, prefix: str) -> "CompoundSymbolName.Component":
            return CompoundSymbolName.Component(
                self.string, prefix, self.suffix, self.joint_to_prev, self.string_case
            )

        def with_string(self, string: str) -> "CompoundSymbolName.Component":
            return CompoundSymbolName.Component(
                string, self.prefix, self.suffix, self.joint_to_prev, self.string_case
            )
        
        def replacing_in_string(self, old: str, new: str) -> "CompoundSymbolName.Component":
            """
            Returns a copy of this `Component`, with any occurrence of `old` within
            `self.string` replaced with `new`.
            """
            return CompoundSymbolName.Component(
                self.string.replace(old, new), self.prefix, self.suffix, self.joint_to_prev, self.string_case
            )

        def with_suffix(self, suffix: str) -> "CompoundSymbolName.Component":
            return CompoundSymbolName.Component(
                self.string, self.prefix, suffix, self.joint_to_prev, self.string_case
            )

        def with_joint_to_prev(self, joint_to_prev: str):
            return CompoundSymbolName.Component(
                self.string, self.prefix, self.suffix, joint_to_prev, self.string_case
            )

        def with_string_case(self, string_case: ComponentCase) -> "CompoundSymbolName.Component":
            return CompoundSymbolName.Component(
                self.string, self.prefix, self.suffix, self.joint_to_prev, string_case
            )

        def lower(self, force=False) -> "CompoundSymbolName.Component":
            """
            Returns a copy of this component with all available strings lowercased.

            >>> CompoundSymbolName.Component(string='SyMBol').lower().to_string(has_previous=False)
            'symbol'

            >>> CompoundSymbolName.Component(string='SyMBol', prefix='pRef', suffix='SuFF', joint_to_prev='_Prev').lower().to_string(has_previous=True)
            '_prevprefsymbolsuff'

            If the component has a forced casing and 'force' is False, the operation returns an unaltered copy 'self':
            >>> CompoundSymbolName.Component(string='SyMBol', prefix='pRef', suffix='SuFF', joint_to_prev='_Prev',
            ...                              string_case=ComponentCase.AS_IS).lower().to_string(has_previous=True)
            '_PrevpRefSyMBolSuFF'

            If 'force' is True, the casing is forced to be lower-case but the string_case is reset to ComponentCase.ANY:
            >>> CompoundSymbolName.Component(string='SyMBol', prefix='pRef', suffix='SuFF', joint_to_prev='_Prev',
            ...                              string_case=ComponentCase.AS_IS).lower(force=True)
            CompoundSymbolName.Component(string=symbol, prefix=pref, prefix=suff, prefix=_prev, string_case=ComponentCase.ANY)
            """

            if not force and self.string_case != ComponentCase.ANY:
                return self

            prefix = self.prefix.lower() if self.prefix is not None else None
            suffix = self.suffix.lower() if self.suffix is not None else None
            joint_to_prev = (
                self.joint_to_prev.lower() if self.joint_to_prev is not None else None
            )

            return CompoundSymbolName.Component(
                self.string.lower(), prefix, suffix, joint_to_prev
            ).with_string_case(ComponentCase.ANY)

        def upper(self, force=False) -> "CompoundSymbolName.Component":
            """
            Returns a copy of this component with all available strings uppercased.

            >>> CompoundSymbolName.Component(string='SyMBol').upper().to_string(has_previous=False)
            'SYMBOL'

            >>> CompoundSymbolName.Component(string='SyMBol', prefix='pRef', suffix='SuFF', joint_to_prev='_Prev').upper().to_string(has_previous=True)
            '_PREVPREFSYMBOLSUFF'

            If the component has a forced casing and 'force' is False, the operation returns an unaltered copy 'self':
            >>> CompoundSymbolName.Component(string='SyMBol', prefix='pRef', suffix='SuFF', joint_to_prev='_Prev',
            ...                              string_case=ComponentCase.AS_IS).upper().to_string(has_previous=True)
            '_PrevpRefSyMBolSuFF'

            If 'force' is True, the casing is forced to be upper-case but the string_case is reset to ComponentCase.ANY:
            >>> CompoundSymbolName.Component(string='SyMBol', prefix='pRef', suffix='SuFF', joint_to_prev='_Prev',
            ...                              string_case=ComponentCase.LOWER).upper(force=True)
            CompoundSymbolName.Component(string=SYMBOL, prefix=PREF, prefix=SUFF, prefix=_PREV, string_case=ComponentCase.ANY)
            """

            if not force and self.string_case != ComponentCase.ANY:
                return self

            prefix = self.prefix.upper() if self.prefix is not None else None
            suffix = self.suffix.upper() if self.suffix is not None else None
            joint_to_prev = (
                self.joint_to_prev.upper() if self.joint_to_prev is not None else None
            )

            return CompoundSymbolName.Component(
                self.string.upper(), prefix, suffix, joint_to_prev
            ).with_string_case(ComponentCase.ANY)

        def to_string(self, has_previous: bool) -> str:
            """
            Returns a string representation of this component.

            Prefix, suffix and joint strings are only emitted if they are present:

            >>> CompoundSymbolName.Component(string='symbol').to_string(has_previous=False)
            'symbol'

            >>> CompoundSymbolName.Component(string='symbol', prefix='pref', suffix='suff').to_string(has_previous=False)
            'prefsymbolsuff'

            If the component has a 'joint_to_prev', it is appended only if has_previous is True:

            >>> CompoundSymbolName.Component(string='symbol', prefix='pref', joint_to_prev='_').to_string(has_previous=True)
            '_prefsymbol'

            If the component has a string_case different than ComponentCase.ANY or ComponentCase.AS_IS, the casing
            is adjusted according to the preference set:
            >>> CompoundSymbolName.Component(string='Symbol', prefix='Pref', suffix='Suff',
            ...                              joint_to_prev='_A',
            ...                              string_case=ComponentCase.LOWER).to_string(has_previous=True)
            '_aprefsymbolsuff'
            """

            result = ""

            if has_previous and self.joint_to_prev is not None:
                result += self.string_case.change_case(self.joint_to_prev)

            if self.prefix is not None:
                result += self.string_case.change_case(self.prefix)

            result += self.string_case.change_case(self.string)

            if self.suffix is not None:
                result += self.string_case.change_case(self.suffix)

            return result
        
        def startswith(self, string: str, has_previous: bool) -> bool:
            """
            Returns `True` if `self.to_string(has_previous=has_previous).startswith(string)`.
            """
            return self.to_string(has_previous=has_previous).startswith(string)
        
        def endswith(self, string: str, has_previous: bool) -> bool:
            """
            Returns `True` if `self.to_string(has_previous=has_previous).endswith(string)`.
            """
            return self.to_string(has_previous=has_previous).endswith(string)
    
    #

    components: list[Component]

    def __init__(self, components: list[Component]):
        if components is None:
            components = []

        for comp in components:
            assert isinstance(comp, CompoundSymbolName.Component)

        self.components = components
    
    def __eq__(self, other) -> bool:
        if isinstance(other, CompoundSymbolName):
            return self.components == other.components
        return False
    
    def __hash__(self) -> int:
        return hash(frozenset(self.components))

    def __getitem__(self, index):
        return self.components[index]

    def __setitem__(self, index, item):
        self.components[index] = item

    def __len__(self) -> int:
        return len(self.components)

    def __iter__(self) -> Iterator[Component]:
        return self.components.__iter__()

    def __repr__(self) -> str:
        if len(self.components) == 0:
            return "CompoundSymbolName(components=[])"

        body = ",\n    ".join(map(lambda c: f"{c}", self.components))
        return f"CompoundSymbolName(components=[\n    {body}\n])"

    @staticmethod
    def from_string_list(*strings: str) -> "CompoundSymbolName":
        components = map(lambda s: CompoundSymbolName.Component(s), strings)

        return CompoundSymbolName(list(components))

    @staticmethod
    def from_snake_case(string: str) -> "CompoundSymbolName":
        components = map(
            lambda s: CompoundSymbolName.Component(s, joint_to_prev="_"),
            string.split("_"),
        )

        return CompoundSymbolName(list(components))

    @classmethod
    def from_pascal_case(cls, string: str) -> "CompoundSymbolName":
        """
        Creates a new symbol name from a given PascalCase or camelCase string.

        >>> CompoundSymbolName.from_pascal_case("APascalCaseString")
        CompoundSymbolName(components=[
            CompoundSymbolName.Component(string=A, prefix=None, prefix=None, prefix=None, string_case=ComponentCase.ANY),
            CompoundSymbolName.Component(string=Pascal, prefix=None, prefix=None, prefix=None, string_case=ComponentCase.ANY),
            CompoundSymbolName.Component(string=Case, prefix=None, prefix=None, prefix=None, string_case=ComponentCase.ANY),
            CompoundSymbolName.Component(string=String, prefix=None, prefix=None, prefix=None, string_case=ComponentCase.ANY)
        ])
        """
        return cls.from_string_list(*_pascal_case_matcher.findall(string))

    def copy(self) -> "CompoundSymbolName":
        return CompoundSymbolName(
            components=list(map(lambda c: c.copy(), self.components))
        )

    def startswith(self, string: str) -> bool:
        """
        Returns True if the computed string for this symbol name starts with a provided string.

        >>> name = CompoundSymbolName.from_snake_case('D3D12_DRED_VERSION')
        >>> name.startswith('D3D12')
        True
        >>> name.startswith('D3D12_DRED')
        True
        >>> name.startswith('DXGI')
        False

        If the symbol name is empty, only empty strings match:

        >>> name = CompoundSymbolName([])
        >>> name.startswith('D3D12')
        False
        >>> name.startswith('')
        True
        """

        if len(self) == 0:
            return string == ""

        return self.to_string().startswith(string)

    def endswith(self, string: str) -> bool:
        """
        Returns True if the computed string for this symbol name ends with a provided string.

        >>> name = CompoundSymbolName.from_snake_case('D3D12_DRED_VERSION')
        >>> name.endswith('VERSION')
        True
        >>> name.endswith('DRED_VERSION')
        True
        >>> name.endswith('DXGI')
        False

        If the symbol name is empty, only empty strings match:

        >>> name = CompoundSymbolName([])
        >>> name.endswith('D3D12')
        False
        >>> name.endswith('')
        True
        """

        if len(self) == 0:
            return string == ""

        return self.to_string().endswith(string)

    def adding_component(
            self,
            string: str,
            prefix: str | None = None,
            suffix: str | None = None,
            joint_to_prev: str | None = None,
            string_case: ComponentCase = ComponentCase.ANY
    ) -> "CompoundSymbolName":
        copy = self.copy()
        copy.components.append(
            CompoundSymbolName.Component(string, prefix, suffix, joint_to_prev, string_case)
        )
        return copy

    def prepending_component(
            self,
            string: str,
            prefix: str | None = None,
            suffix: str | None = None,
            joint_to_prev: str | None = None,
            string_case: ComponentCase = ComponentCase.ANY
    ) -> "CompoundSymbolName":
        copy = self.copy()
        copy.components.insert(
            0, CompoundSymbolName.Component(string, prefix, suffix, joint_to_prev, string_case)
        )
        return copy
    
    def mapping_components(self, mapper: Callable[[int, "CompoundSymbolName.Component"], "CompoundSymbolName.Component"]):
        copy = self.copy()
        for i, comp in enumerate(copy):
            copy[i] = mapper(i, comp)
        
        return copy

    def lower(self, force=False) -> "CompoundSymbolName":
        """
        Returns a copy of this CompoundSymbolName with every component lower-cased.

        If this compound symbol name has any component where the casing is pinned to some value other than
        ComponentCase.ANY, the casing of that element is manitained.

        >>> c = CompoundSymbolName.from_string_list('A', 'Symbol', 'NAME')
        >>> c.components[2].string_case = ComponentCase.UPPER
        >>> c.lower(force=False).to_string()
        'asymbolNAME'

        Passing force=True resets the casing of the components to ComponentCase.ANY and the string is lowercased:
        >>> c.lower(force=True).to_string()
        'asymbolname'
        """
        copy = self.copy()
        for i, comp in enumerate(copy):
            copy[i] = comp.lower(force=force)

        return copy

    def upper(self, force=False) -> "CompoundSymbolName":
        """
        Returns a copy of this CompoundSymbolName with every component upper-cased.

        If this compound symbol name has any component where the casing is pinned to some value other than
        ComponentCase.ANY, the casing of that element is manitained.

        >>> c = CompoundSymbolName.from_string_list('A', 'Symbol', 'name')
        >>> c.components[2].string_case = ComponentCase.LOWER
        >>> c.upper(force=False).to_string()
        'ASYMBOLname'

        Passing force=True resets the casing of the components to ComponentCase.ANY and the string is uppercased:
        >>> c.upper(force=True).to_string()
        'ASYMBOLNAME'
        """

        copy = self.copy()
        for i, comp in enumerate(copy):
            copy[i] = comp.upper(force=force)

        return copy

    def removing_prefixes(self, prefixes: list[str], case_sensitive=True) -> "CompoundSymbolName":
        """
        Returns a new CompoundSymbolName with any compound whose string matches a string in 'prefixes' removed.

        The matching can be done in a case-sensitive or insensitive manner according to the `case_sensitive` parameter.
        Defaults to case-sensitive.

        >>> name = CompoundSymbolName.from_snake_case('D3D12_DRED_VERSION')
        >>> name.removing_prefixes(['D3D12']).to_string()
        'DRED_VERSION'

        >>> name = CompoundSymbolName.from_snake_case('d3d12_dred_version')
        >>> name.removing_prefixes(['D3D12'], case_sensitive=False).to_string()
        'dred_version'
        """

        index = 0
        for comp in self:
            if not case_sensitive:
                for prefix in prefixes:
                    if comp.string.lower() == prefix.lower():
                        index += 1
                    else:
                        break
            else:
                if comp.string in prefixes:
                    index += 1
                else:
                    break

        return CompoundSymbolName(self.copy().components[index:])

    def removing_common(
            self, other: "CompoundSymbolName", case_sensitive: bool = True, detect_plurals: bool = True
    ) -> Tuple["CompoundSymbolName", Optional["CompoundSymbolName"]]:
        """
        Returns a new CompoundSymbolName with the common prefix between it and another CompoundSymbolName removed.

        In case the generated name would produce an invalid Swift identifier, like starting with a digit instead of a letter, an extra
        prefix is provided as a second element to the return's tuple:

        >>> enum      = CompoundSymbolName.from_snake_case('D3D12_DRED_VERSION')
        >>> enum_case = CompoundSymbolName.from_snake_case('D3D12_DRED_VERSION_1_0')
        >>> enum_case.removing_common(enum)
        (CompoundSymbolName(components=[
            CompoundSymbolName.Component(string=1, prefix=None, prefix=None, prefix=_, string_case=ComponentCase.ANY),
            CompoundSymbolName.Component(string=0, prefix=None, prefix=None, prefix=_, string_case=ComponentCase.ANY)
        ]),
        CompoundSymbolName(components=[
            CompoundSymbolName.Component(string=VERSION, prefix=None, prefix=None, prefix=_, string_case=ComponentCase.ANY)
        ]))

        Optionally allows detecting differences in plurals, e.g.

        >>> enum      = CompoundSymbolName.from_snake_case('D3D12_RAY_FLAGS')
        >>> enum_case = CompoundSymbolName.from_snake_case('D3D12_RAY_FLAG_NONE')
        >>> enum_case.removing_common(enum, detect_plurals=True)[0]
        CompoundSymbolName(components=[
            CompoundSymbolName.Component(string=NONE, prefix=None, prefix=None, prefix=_, string_case=ComponentCase.ANY)
        ])

        >>> enum_case.removing_common(enum, detect_plurals=False)[0]
        CompoundSymbolName(components=[
            CompoundSymbolName.Component(string=FLAG, prefix=None, prefix=None, prefix=_, string_case=ComponentCase.ANY),
            CompoundSymbolName.Component(string=NONE, prefix=None, prefix=None, prefix=_, string_case=ComponentCase.ANY)
        ])
        """

        new_name = CompoundSymbolName([])

        prefix_index = 0
        for index in range(min(len(self.components), len(other.components))):
            if detect_plurals:
                if self.components[index].string.lower() + "s" == other.components[index].string.lower():
                    prefix_index += 1
                    continue
                if self.components[index].string.lower() == other.components[index].string.lower() + "s":
                    prefix_index += 1
                    continue
            
            if case_sensitive:
                if self.components[index].string != other.components[index].string:
                    break
            else:
                if self.components[index].string.lower() != other.components[index].string.lower():
                    break

            prefix_index += 1

        # Detect names starting with digits and relax the prefix index until we
        # reach a name that does not start with a digit.
        extra_prefix_index = prefix_index
        while extra_prefix_index > 0 and self.components[extra_prefix_index].string[0].isdigit():
            extra_prefix_index -= 1

        new_name.components = list(self.components[prefix_index:])

        if extra_prefix_index != prefix_index:
            prefix_name = CompoundSymbolName([])
            prefix_name.components = list(
                self.copy().components[extra_prefix_index:prefix_index]
            )

            return new_name, prefix_name
        else:
            return new_name, None

    def lower_snake_cased(self, force=False) -> "CompoundSymbolName":
        """
        Returns a new compound name where each component is a component from this
        compound name that when put together with to_string() forms a lower_case_snake_cased_string.

        >>> CompoundSymbolName.from_string_list('A', 'Symbol', 'Name').lower_snake_cased().to_string()
        'a_symbol_name'

        If this compound symbol name has any component where the casing is pinned to some value other than
        ComponentCase.ANY, the casing of that element is manitained.

        >>> c = CompoundSymbolName.from_string_list('A', 'Symbol', 'NAME')
        >>> c.components[2].string_case = ComponentCase.UPPER
        >>> c.lower_snake_cased(force=False).to_string()
        'a_symbol_NAME'

        Passing force=True resets the casing of the components to ComponentCase.ANY and the string is lowercased:
        >>> c.lower_snake_cased(force=True).to_string()
        'a_symbol_name'
        """

        result: list[CompoundSymbolName.Component] = []

        for comp in self.components:
            result.append(comp.with_string_only().lower(force=force).with_joint_to_prev("_"))

        return CompoundSymbolName(components=result)

    def pascal_cased(self) -> "CompoundSymbolName":
        """
        Returns a new compound name where each component is a component from this
        compound name that when put together with to_string() forms a PascalCaseString.

        >>> CompoundSymbolName.from_string_list('a', 'symbol', 'name').pascal_cased().to_string()
        'ASymbolName'
        """

        result: list[CompoundSymbolName.Component] = []

        for comp in self.components:
            new_comp = CompoundSymbolName.Component(comp.string.capitalize())

            result.append(new_comp)

        return CompoundSymbolName(components=result)

    def camel_cased(self, digit_separator: str = "_") -> "CompoundSymbolName":
        """
        Returns a new compound name where each component is a component from this
        compound name that when put together with to_string() forms a camelCaseString.

        >>> CompoundSymbolName.from_string_list('a', 'symbol', 'name').camel_cased().to_string()
        'aSymbolName'

        If two adjacent components have digits on each end, digit_separator will be added as a
        joint to the second component:

        >>> CompoundSymbolName.from_string_list('target', '1', '0').camel_cased().to_string()
        'target1_0'
        """

        result: list[CompoundSymbolName.Component] = []

        for i, comp in enumerate(self.components):
            new_comp = comp.with_string_only().lower()

            if i > 0:
                new_comp.string = new_comp.string.capitalize()
                if (
                        new_comp.to_string(True)[0].isdigit()
                        and self.components[i - 1].to_string(i > 1)[-1].isdigit()
                ):
                    new_comp = new_comp.with_joint_to_prev(digit_separator)

            result.append(new_comp)

        return CompoundSymbolName(components=result)

    def to_string(self) -> str:
        return "".join(
            map(lambda c: c[1].to_string(c[0] > 0), enumerate(self.components))
        )


if __name__ == "__main__":
    import doctest

    doctest.testmod(optionflags=doctest.NORMALIZE_WHITESPACE)
