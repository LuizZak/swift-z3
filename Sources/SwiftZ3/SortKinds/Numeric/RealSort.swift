/// A real number sort.
/// Note that this type is not a floating point number.
public struct RealSort: NumericalSort, IntOrRealSort {
    /// Returns a Real sort.
    /// Note that this type is not a floating point number.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.realSort()
    }
}
