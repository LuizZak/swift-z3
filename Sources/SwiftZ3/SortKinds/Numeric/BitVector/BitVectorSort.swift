/// Protocol for bit vectors numerical sorts.
public protocol BitVectorSort: NumericalSort {
    /// Bit-width of vector sort
    static var bitWidth: UInt32 { get }
}

public extension BitVectorSort {
    /// Returns a bit vector sort with the number of bits described by `Self.bitWidth`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: bitWidth)
    }
}
