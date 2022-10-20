from utils.data.swift_decl_visit_result import SwiftDeclVisitResult


class SwiftDeclVisitor(object):
    """A base SwiftDeclVisitor class for visiting SwiftDecl nodes.
    Subclass it and define your own visit_XXX methods, where
    XXX is the class name you want to visit with these
    methods.

    For example:

    class ExtensionVisitor(SwiftDeclVisitor):
        def __init__(self):
            self.exts = []

        def visit_SwiftExtensionDecl(self, node):
            self.exts.append(node.value)

    Creates a list of all the extension nodes encountered below the given
    node. To use it:

    cv = ExtensionVisitor()
    cv.visit(node)

    Notes:

    *   generic_visit() will be called for AST nodes for which
        no visit_XXX method was defined.
    *   The children of nodes for which a visit_XXX was
        defined will not be visited - if you need this, call
        generic_visit() on the node.
        You can use:
            SwiftDeclVisitor.generic_visit(self, node)
    *   Modeled after Python's own AST visiting facilities
        (the ast module of Python 3.0)
    *   Based off of pycparser's implementation
    """

    _visit_cache: dict | None = None
    _post_visit_cache: dict | None = None

    def visit(self, node):
        """Visit a node."""

        if self._visit_cache is None:
            self._visit_cache = {}

        visitor = self._visit_cache.get(node.__class__.__name__, None)
        if visitor is None:
            method = "visit_" + node.__class__.__name__
            visitor = getattr(self, method, self.generic_visit)
            self._visit_cache[node.__class__.__name__] = visitor

        return visitor(node)

    def post_visit(self, node):
        """Post visits a node."""

        if self._post_visit_cache is None:
            self._post_visit_cache = {}

        visitor = self._post_visit_cache.get(node.__class__.__name__, None)
        if visitor is None:
            method = "post_" + node.__class__.__name__
            visitor = getattr(self, method, self.generic_post_visit)
            self._post_visit_cache[node.__class__.__name__] = visitor

        return visitor(node)

    def generic_visit(self, node):
        """Called if no explicit visitor function exists for a
        node. Returns SwiftDeclVisitResult.VISIT_CHILDREN by default
        """
        return SwiftDeclVisitResult.VISIT_CHILDREN

    def generic_post_visit(self, node):
        """Called if no explicit post-visit function exists for a
        node.
        """
        pass
