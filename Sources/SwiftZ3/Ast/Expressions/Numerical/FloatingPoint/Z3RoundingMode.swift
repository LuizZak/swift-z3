/// A typealias for a Z3Ast with a `RoundingModeSort` sort.
public typealias Z3RoundingMode = Z3Ast<RoundingModeSort>

public extension Z3RoundingMode {
    /// Gets the statically-typed Z3Sort associated with `RoundingModeSort` from
    /// this `Z3RoundingMode`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        T.getSort(context)
    }
}
