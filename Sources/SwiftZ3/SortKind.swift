/// Protocol for types that represent Z3 sorts.
public protocol SortKind {
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
    static func isAssignableFrom(_ context: Z3Context, _ sort: Z3Sort) -> Bool {
        getSort(context) == sort
    }
}
