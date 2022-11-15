/// Type alias for a generic `Z3Ast` bit-vector instance that features an underlying
/// AST that is a non-specific sized bit vector.
public typealias AnyZ3BitVector = Z3Ast<AnyBitVectorSort>

public extension AnyZ3BitVector {
    /// Create an integer from this bit-vector.
    ///
    /// If `isSigned` is false, then this bit-vector is treated as unsigned.
    /// So the result is non-negative and in the range `[0..2^N-1]`, where N are
    /// the number of bits in this bit-vector.
    /// If `isSigned` is true, this bit-vector is treated as a signed bit-vector.
    func toInt(isSigned: Bool) -> Z3Int {
        context.makeBvToIntAny(self, isSigned: isSigned)
    }
}
