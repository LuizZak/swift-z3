from enum import Enum


class SwiftDeclVisitResult(Enum):
    """
    Defines the behavior of a SwiftDeclVisitor as it visits declarations.
    """

    VISIT_CHILDREN = 0
    "The visitor should visit the children of a declaration."
    SKIP_CHILDREN = 1
    "The visitor should skip the children of a declaration."
