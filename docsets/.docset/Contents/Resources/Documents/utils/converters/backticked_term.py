SWIFT_KEYWORDS = [
    "actor",
    "as",
    "case",
    "class",
    "default",
    "do",
    "else",
    "extension",
    "for",
    "if",
    "in",
    "is",
    "let",
    "repeat",
    "set",
    "struct",
    "var",
    "while",
]
"List of Swift keywords that generators should avoid using without `backticks`"


def backticked_term(term: str) -> str:
    if term in SWIFT_KEYWORDS:
        return f"`{term}`"

    return term
