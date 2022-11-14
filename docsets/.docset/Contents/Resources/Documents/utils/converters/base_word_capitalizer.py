import re


class BaseWordCapitalizer:
    def suggest_capitalization(
        self, string: str, has_leading_string: bool
    ) -> tuple[str, int, int] | None:
        """
        Request that this word capitalizer suggest a capitalization for a given
        input string, with a flag used to indicate if the string is the continuation
        of a split string.

        Capitalization should be responded with the earliest substring instance
        that should be capitalized, as a tuple of ('word', string[startIndex:], string[:endIndex]).

        For no capitalization suggestions on a given string, 'None' can be returned.
        """
        raise NotImplementedError()


class WordCapitalizer(BaseWordCapitalizer):
    """
    Capitalizes an occurrence of a given word as a substring of an input string.

    E.g.: To uppercase 'sse2' in 'x86_sse2' into 'x86_SSE2, initialize as `WordCapitalizer(word="sse2")`.
    """

    word: str

    def __init__(self, word: str) -> None:
        self.word = word

    def suggest_capitalization(
        self, string: str, has_leading_string: bool
    ) -> tuple[str, int, int] | None:
        pattern = re.compile(f"({self.word})", flags=re.IGNORECASE)

        leftmost_interval = None

        for match in pattern.finditer(string):
            if leftmost_interval is None or match.start() < leftmost_interval[1]:
                leftmost_interval = (
                    self.word,
                    match.start(),
                    match.end(),
                )
            else:
                break

        return leftmost_interval


class PatternCapitalizer(BaseWordCapitalizer):
    """
    Capitalizes a word in a string using a regex matcher that will capitalize the
    terms in the match pattern that are enclosed in the first capture group, e.g.:

    `PatternCapitalizer(re.compile(r"rect(i)", flags=re.IGNORECASE))` will capitalize
    the '-i' in 'recti', but not 'rect-'.
    """

    pattern: str | re.Pattern
    """
    A regex pattern with at least one capture group to which capitalization will be done.
    """

    ignore_if_is_leading_string: bool = False
    """
    If `True`, capitalization suggestion is skipped if `has_leading_string` is `False` in
    `self.suggest_capitalization()`, indicating that the string is the start of a string that
    was previously split by a formatter.
    """

    def __init__(
        self, pattern: str | re.Pattern, ignore_if_is_leading_string: bool = False
    ) -> None:
        self.pattern = pattern
        self.ignore_if_is_leading_string = ignore_if_is_leading_string

    def suggest_capitalization(
        self, string: str, has_leading_string: bool
    ) -> tuple[str, int, int] | None:
        leftmost_interval = None

        if self.ignore_if_is_leading_string and not has_leading_string:
            return None

        pat: re.Pattern = (
            self.pattern
            if isinstance(self.pattern, re.Pattern)
            else re.compile(self.pattern)
        )

        for match in pat.finditer(string):
            if leftmost_interval is None or match.start() < leftmost_interval[1]:
                leftmost_interval = (
                    match.group(1).upper(),
                    match.start(1),
                    match.end(1),
                )
            else:
                break

        return leftmost_interval
