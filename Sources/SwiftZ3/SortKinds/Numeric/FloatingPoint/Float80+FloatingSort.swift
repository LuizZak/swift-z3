#if !os(Windows) && (arch(i386) || arch(x86_64))
extension Float80: FloatingSort {
    /// Returns an 80-bit FloatingPoint sort.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPointSort(ebits: 15, sbits: 63)
    }
}
#endif
