/// Protocol for types that represent Z3 sorts.
public protocol SortKind {
    static func getSort(_ context: Z3Context) -> Z3Sort
}
