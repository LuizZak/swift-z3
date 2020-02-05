import CZ3

public extension Z3Context {
    // MARK: - Bit-vectors
    
    /// Creates a bit vector out of a given integer value.
    func makeBitVector<T: BitVectorSort>(_ value: Int32) -> Z3Ast<T> {
        return Z3Ast(context: self,
                     ast: Z3_mk_int(context, value, T.getSort(self).sort))
    }
    
    /// Creates a bit vector out of a given integer value.
    func makeBitVector<T: BitVectorSort>(_ value: Int64) -> Z3Ast<T> {
        return Z3Ast(context: self,
                     ast: Z3_mk_int64(context, value, T.getSort(self).sort))
    }
    
    /// Creates a bit vector out of a given integer value.
    func makeBitVectorAny(_ value: Int32, bitWidth: UInt32) -> AnyZ3Ast {
        return AnyZ3Ast(context: self,
                        ast: Z3_mk_int(context, value, bitVectorSort(size: bitWidth).sort))
    }

    /// Bitwise negation.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeBvNot<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvnot(context, t1.ast))
    }

    /// Take conjunction of bits in vector, return vector of length 1.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeBvRedAnd<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<BitVectorSort1> {
        return Z3Ast(context: self, ast: Z3_mk_bvredand(context, t1.ast))
    }

    /// Take disjunction of bits in vector, return vector of length 1.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeBvRedOr<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<BitVectorSort1> {
        return Z3Ast(context: self, ast: Z3_mk_bvredor(context, t1.ast))
    }

    /// Bitwise and.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvAnd<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvand(context, t1.ast, t2.ast))
    }

    /// Bitwise or.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvOr<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvor(context, t1.ast, t2.ast))
    }

    /// Bitwise exclusive-or.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvXor<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvxor(context, t1.ast, t2.ast))
    }

    /// Bitwise nand.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvNand<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvnand(context, t1.ast, t2.ast))
    }

    /// Bitwise nor.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvNor<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvnor(context, t1.ast, t2.ast))
    }

    /// Bitwise xnor.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvXnor<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvxnor(context, t1.ast, t2.ast))
    }

    /// Standard two's complement unary minus.
    ///
    /// The node `t1` must have bit-vector sort.
    func makeBvNeg<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvneg(context, t1.ast))
    }

    /// Standard two's complement addition.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvAdd<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvadd(context, t1.ast, t2.ast))
    }

    /// Standard two's complement subtraction.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvSub<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvsub(context, t1.ast, t2.ast))
    }

    /// Standard two's complement multiplication.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvMul<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvmul(context, t1.ast, t2.ast))
    }

    /// Unsigned division.
    ///
    /// It is defined as the `floor` of `t1/t2` if `t2` is different from zero.
    /// If `t2` is zero, then the result is undefined.
    func makeBvDiv<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvudiv(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed division.
    ///
    /// It is defined in the following way:
    ///
    /// - The `floor` of `t1/t2` if `t2` is different from zero, and `t1*t2 >= 0`.
    ///
    /// - The `ceiling` of `t1/t2` if `t2` is different from zero, and `t1*t2 < 0`.
    ///
    /// If `t2` is zero, then the result is undefined.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvSDiv<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvsdiv(context, t1.ast, t2.ast))
    }
    
    /// Unsigned remainder.
    ///
    /// It is defined as `t1 - (t1 /u t2) * t2`, where `/u` represents unsigned
    /// division.
    ///
    /// If `t2` is zero, then the result is undefined.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvURem<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvurem(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed remainder (sign follows dividend).
    ///
    /// It is defined as `t1 - (t1 /s t2) * t2`, where `/s` represents signed
    /// division.
    /// The most significant bit (sign) of the result is equal to the most
    /// significant bit of `t1`.
    ///
    /// If `t2` is zero, then the result is undefined.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    ///
    /// - seealso: `makeBvSMod`
    func makeBvSRem<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvsrem(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed remainder (sign follows divisor).
    ///
    /// If `t2` is zero, then the result is undefined.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// - seealso: `makeBvSRem`
    func makeBvSMod<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvsmod(context, t1.ast, t2.ast))
    }
    
    /// Unsigned less than.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvUlt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvult(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed less than.
    ///
    /// It abbreviates:
    ///
    /// ```
    /// (or (and (= (extract[|m-1|:|m-1|] t1) bit1)
    ///         (= (extract[|m-1|:|m-1|] t2) bit0))
    ///     (and (= (extract[|m-1|:|m-1|] t1) (extract[|m-1|:|m-1|] t2))
    ///         (bvult t1 t2)))
    /// ```
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvSlt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvslt(context, t1.ast, t2.ast))
    }
    
    /// Unsigned less than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvUle<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvule(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed less than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvSle<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvsle(context, t1.ast, t2.ast))
    }
    
    /// Unsigned greater than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvUge<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvuge(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed greater than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvSge<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvsge(context, t1.ast, t2.ast))
    }
    
    /// Unsigned greater than.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvUgt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvugt(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed greater than.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvSgt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_bvsgt(context, t1.ast, t2.ast))
    }
    
    /// Concatenate the given bit-vectors.
    ///
    /// The nodes `t1` and `t2` must have (possibly different) bit-vector sorts
    ///
    /// The result is a bit-vector of size `n1+n2`, where `n1` (`n2`)
    /// is the size of `t1` (`t2`).
    ///
    func makeConcat<T: BitVectorSort, U: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<U>) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_bvsgt(context, t1.ast, t2.ast))
    }
    
    /// Extract the bits `high` down to `low` from a bit-vector of
    /// size `m` to yield a new bit-vector of size `n`, where `n = high - low + 1`.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeExtract<T: BitVectorSort>(high: UInt32, low: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_extract(context, high, low, t1.ast))
    }
    
    /// Sign-extend of the given bit-vector to the (signed) equivalent bit-vector
    /// of size `m+i`, where `m` is the size of the given bit-vector.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeSignExtend<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_sign_ext(context, i, t1.ast))
    }
    
    /// Extend the given bit-vector with zeros to the (unsigned) equivalent
    /// bit-vector of size `m+i`, where `m` is the size of the given bit-vector.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeZeroExtend<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_zero_ext(context, i, t1.ast))
    }
    
    /// Repeat the given bit-vector up length `i`.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeRepeat<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_repeat(context, i, t1.ast))
    }
    
    /// Shift left.
    ///
    /// It is equivalent to multiplication by `2^x` where `x` is the value of the
    /// second argument.
    ///
    /// NB. The semantics of shift operations varies between environments. This
    /// definition does not necessarily capture directly the semantics of the
    /// programming language or assembly architecture you are modeling.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvShl<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(context: self, ast: Z3_mk_bvshl(context, t1.ast, t2.ast))
    }
    
    /// Logical shift right.
    ///
    /// It is equivalent to unsigned division by `2^x` where `x` is the value of
    /// the second argument.
    ///
    /// NB. The semantics of shift operations varies between environments. This
    /// definition does not necessarily capture directly the semantics of the
    /// programming language or assembly architecture you are modeling.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvLShr<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(context: self, ast: Z3_mk_bvlshr(context, t1.ast, t2.ast))
    }
    
    /// Arithmetic shift right.
    ///
    /// It is like logical shift right except that the most significant bits of
    /// the result always copy the most significant bit of the second argument.
    ///
    /// The semantics of shift operations varies between environments. This
    /// definition does not necessarily capture directly the semantics of the
    /// programming language or assembly architecture you are modeling.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeBvAShr<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(context: self, ast: Z3_mk_bvashr(context, t1.ast, t2.ast))
    }
    
    /// Rotate bits of `t1` to the left `i` times.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeRotateLeft<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(context: self, ast: Z3_mk_rotate_left(context, i, t1.ast))
    }
    
    /// Rotate bits of `t1` to the right `i` times.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeRotateRight<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(context: self, ast: Z3_mk_rotate_right(context, i, t1.ast))
    }
    
    /// Rotate bits of `t1` to the left `t2` times.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeExtRotateLeft<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(context: self, ast: Z3_mk_ext_rotate_left(context, t1.ast, t2.ast))
    }
    
    /// Rotate bits of `t1` to the right `t2` times.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    func makeExtRotateRight<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(context: self, ast: Z3_mk_ext_rotate_right(context, t1.ast, t2.ast))
    }
    
    /// Create an `n` bit bit-vector from the integer argument `t1`.
    ///
    /// The resulting bit-vector has `n` bits, where the i'th bit (counting
    /// from 0 to `n-1`) is 1 if `(t1 div 2^i)` mod 2 is 1.
    ///
    /// The node `t1` must have integer sort.
    func makeInt2Bv<T: IntegralSort>(_ n: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_int2bv(context, n, t1.ast))
    }

    /// Create an integer from the bit-vector argument `t1`.
    ///
    /// If `isSigned` is false, then the bit-vector `t1` is treated as unsigned.
    /// So the result is non-negative and in the range `[0..2^N-1]`, where N are
    /// the number of bits in `t1`.
    /// If `isSigned` is true, `t1` is treated as a signed bit-vector.
    ///
    /// The node `t1` must have a bit-vector sort.
    func makeBv2Int<T: BitVectorSort>(_ t1: Z3Ast<T>, isSigned: Bool) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_bv2int(context, t1.ast, isSigned))
    }
    
    /// Create a predicate that checks that the bit-wise addition of `t1` and
    /// `t2` does not overflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvAddNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvadd_no_overflow(context, t1.ast, t2.ast, isSigned))
    }
    
    /// Create a predicate that checks that the bit-wise addition of `t1` and
    /// `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvAddNoUnderflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvadd_no_underflow(context, t1.ast, t2.ast))
    }
    
    /// Create a predicate that checks that the bit-wise subtraction of `t1` and
    /// `t2` does not overflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvSubNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvsub_no_overflow(context, t1.ast, t2.ast))
    }
    
    /// Create a predicate that checks that the bit-wise subtraction of `t1` and
    /// `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvSubNoUnderflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvsub_no_underflow(context, t1.ast, t2.ast, isSigned))
    }
    
    /// Create a predicate that checks that the bit-wise signed division of `t1`
    /// and `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvSDivNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvsdiv_no_overflow(context, t1.ast, t2.ast))
    }
    
    /// Check that bit-wise negation does not overflow when `t1` is interpreted
    /// as a signed bit-vector.
    ///
    /// The node `t1` must have bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvNegNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvneg_no_overflow(context, t1.ast))
    }
    
    /// Create a predicate that checks that the bit-wise multiplication of `t1`
    /// and `t2` does not overflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvMulNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvmul_no_overflow(context, t1.ast, t2.ast, isSigned))
    }
    
    /// Create a predicate that checks that the bit-wise multiplication of `t1`
    /// and `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    func makeBvMulNoUnderflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_bvmul_no_underflow(context, t1.ast, t2.ast))
    }

    /// Create a bit-vector numeral from a vector of Booleans.
    ///
    /// - seealso: `makeNumeral`
    func makeBvNumeral(_ bits: [Bool]) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_bv_numeral(context, UInt32(bits.count), bits))
    }
}
