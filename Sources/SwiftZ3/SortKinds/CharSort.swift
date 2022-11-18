/// A unicode character sort.
public struct CharSort: ArithmeticSort {
    /// Returns the unicode character sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.charSort()
    }
}
