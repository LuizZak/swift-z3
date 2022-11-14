/// Protocol for floating-point numerical sorts.
public protocol FloatingSort: NumericalSort {
    /// Retrieves the number of bits reserved for the exponent in this
    /// `FloatingPoint` sort.
    static func getEbits(_ context: Z3Context) -> UInt32

    /// Retrieves the number of bits reserved for the significand in this
    /// `FloatingPoint` sort.
    static func getSbits(_ context: Z3Context) -> UInt32
}

public extension FloatingSort {
    /// Retrieves the number of bits reserved for the exponent in this
    /// `FloatingPoint` sort.
    static func getEbits(_ context: Z3Context) -> UInt32 {
        context.fpaGetEbits(sort: self)
    }

    /// Retrieves the number of bits reserved for the significand in this
    /// `FloatingPoint` sort.
    static func getSbits(_ context: Z3Context) -> UInt32 {
        context.fpaGetSbits(sort: self)
    }
}
