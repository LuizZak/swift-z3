/// Protocol for types that represent Z3 sorts.
public protocol SortKind {
    /// Whether this is a concrete Sort kind, that is, it can be used to generate
    /// valid `Z3Sort` instances, or whether it represents a generic arrangement
    /// of sort categories.
    ///
    /// Calling `Self.getSort()` on non-concrete sort kinds results in runtime
    /// errors.
    static var isConcrete: Bool { get }

    /// Creates a concrete instance of a Z3 sort that represents this sort kind.
    static func getSort(_ context: Z3Context) -> Z3Sort

    /// Returns whether this sort kind can be used to represent a more specialized
    /// typed `Z3Ast` instance with a given sort.
    ///
    /// Used for cross casts and downcasts of `Z3Ast<T>` and `AnyZ3Ast`.
    ///
    /// Always returns `true` if `sort` is the same as `self.getSort(context)`.
    static func isAssignableFrom(_ context: Z3Context, _ sort: Z3Sort) -> Bool
}

public extension SortKind {
    static var isConcrete: Bool { true }

    static func isAssignableFrom(_ context: Z3Context, _ sort: Z3Sort) -> Bool {
        getSort(context) == sort
    }
}
