/// An integer sort.
/// Note that this is not the same as a machine integer.
public struct IntSort: ArithmeticSort {
    /// Returns an integer sort.
    /// Note that this is not the same as a machine integer.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
