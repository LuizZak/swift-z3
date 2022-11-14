/// A `RoundingMode` sort for values that specify the rounding mode of floating
/// point values
public struct RoundingModeSort: SortKind {
    /// Returns a floating-point Rounding Mode sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.makeFpaRoundingModeSort()
    }
}
