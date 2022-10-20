from utils.data.swift_decl_visit_result import SwiftDeclVisitResult
from utils.data.swift_decl_visitor import SwiftDeclVisitor
from utils.data.swift_decls import SwiftDecl, SwiftDeclWalker


class _PreCachingVisitor(SwiftDeclVisitor):
    decl_stack: list[SwiftDecl]
    _cached_results: dict[str, str]

    def __init__(self):
        self.decl_stack = list()
        self._cached_results = dict()

    def generic_visit(self, decl: SwiftDecl) -> SwiftDeclVisitResult:
        if decl.original_name is not None:
            c_name = decl.original_name.to_string()

            # Create fully-qualified member name
            fully_qualified = ".".join(
                map(lambda s: s.name.to_string(), self.decl_stack + [decl])
            )

            self._cached_results[c_name.lower()] = fully_qualified

        self.decl_stack.append(decl)
        return SwiftDeclVisitResult.VISIT_CHILDREN

    def generic_post_visit(self, decl: SwiftDecl):
        self.decl_stack.pop()


class SwiftDeclLookup:
    """
    Supports looking up Swift symbol names based on original C symbols.
    """

    _cached_results: dict[str, str]

    def __init__(self, decls: list[SwiftDecl]):
        self.decls = decls
        self._cached_results = dict()

        visitor = _PreCachingVisitor()
        walker = SwiftDeclWalker(visitor)

        for decl in self.decls:
            walker.walk_decl(decl)

        self._cached_results = visitor._cached_results

    def lookup_c_symbol(self, c_symbol: str) -> str | None:
        """
        Looks up C symbol names, returning the equivalent partially-qualified \
        Swift declaration name that represents that symbol.

        Lookups return a string that represents the module-level qualified accessor \
        for the symbol, e.g.:
        
        ```
        'A_C_ENUM' -> 'ACEnum'
        'A_C_ENUM_CASE' -> 'ACEnum.aCEnumCase'
        ```
        """

        return self._cached_results.get(c_symbol.lower())
