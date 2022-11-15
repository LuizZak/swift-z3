extension Double: FloatingSort {
    /// Returns a 64-bit FloatingPoint sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint64Sort()
    }
}
