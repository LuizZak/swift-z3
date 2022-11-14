/// A Quadruple-precision floating point sort
public struct FP128Sort: FloatingSort {
    /// Returns a 128-bit FloatingPoint sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint128Sort()
    }
}
