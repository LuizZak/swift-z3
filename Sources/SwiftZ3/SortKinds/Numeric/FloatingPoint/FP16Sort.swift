/// A half precision floating point sort
public struct FP16Sort: FloatingSort {
    /// Returns a 16-bit FloatingPoint sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint16Sort()
    }
}
