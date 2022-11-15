extension Float: FloatingSort {
    /// Returns a 32-bit FloatingPoint sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint32Sort()
    }
}
