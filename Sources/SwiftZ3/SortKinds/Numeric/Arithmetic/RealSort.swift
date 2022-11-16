/// A real number sort.
/// Note that this type is not a floating point number.
public struct RealSort: ArithmeticSort {
    /// Returns a Real sort.
    /// Note that this type is not a floating point number.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.realSort()
    }
}
