import Z3

public class Z3Context {
    internal var context: Z3_context

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context(configuration?.config)
    }

    deinit {
        Z3_del_context(context)
    }
    
    public func makeSolver() -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_solver(context))
    }
    
    // MARK: - Sorts
    
    /// Create the integer type.
    ///
    /// This type is not the int type found in programming languages.
    /// A machine integer can be represented using bit-vectors. The function
    /// `Z3_mk_bv_sort` creates a bit-vector type.
    ///
    /// - seealso: `Z3_mk_bv_sort`
    public func intSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_int_sort(context))
    }

    /// Create the Boolean type.
    /// This type is used to create propositional variables and predicates.
    public func boolSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_bool_sort(context))
    }

    /// Create the real type.
    ///
    /// Note that this type is not a floating point number.
    public func realSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_real_sort(context))
    }

    /// Create a bit-vector type of the given size.
    /// This type can also be seen as a machine integer.
    ///
    /// - remark: The size of the bit-vector type must be greater than zero.
    public func bitVectorSort(size: UInt32) -> Z3Sort {
        precondition(size > 0)
        return Z3Sort(sort: Z3_mk_bv_sort(context, size))
    }

    // MARK: -
    
    /// Declare and create a constant.
    ///
    /// This function is a shorthand for:
    /// ```
    /// Z3_func_decl d = Z3_mk_func_decl(c, s, 0, 0, ty);
    /// Z3_ast n       = Z3_mk_app(c, d, 0, 0);
    /// ```
    public func makeConstant<T: SortKind>(name: String, sort: T.Type) -> Z3Ast<T> {
        let symbol = Z3_mk_string_symbol(context, name)

        return Z3Ast(ast: Z3_mk_const(context, symbol, sort.getSort(self).sort))
    }

    /// \brief Create a numeral of a given sort.
    ///
    /// - seealso: `makeInteger()`
    /// - seealso: `makeUnsignedInteger()`
    /// - Parameter number: A string representing the numeral value in decimal
    /// notation. The string may be of the form `[num]*[.[num]*][E[+|-][num]+]`.
    /// If the given sort is a real, then the numeral can be a rational, that is,
    /// a string of the form `[num]* / [num]*` .
    /// - Parameter sort: The sort of the numeral. In the current implementation,
    /// the given sort can be an int, real, finite-domain, or bit-vectors of
    /// arbitrary size.
    public func makeNumeral<T: NumericalSort>(number: String, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_numeral(context, number, sort.getSort(self).sort))
    }

    /// Create a real from a fraction.
    ///
    /// - Parameter num: numerator of rational.
    /// - Parameter den: denominator of rational.
    /// - seealso: `Z3_mk_numeral`
    /// - seealso: `Z3_mk_int`
    /// - seealso: `Z3_mk_unsigned_int`
    /// - precondition: `den != 0`
    public func makeReal(_ num: Int32, _ den: Int32) -> Z3Ast<RealSort> {
        return Z3Ast(ast: Z3_mk_real(context, num, den))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger(value: Int32) -> Z3Ast<IntSort> {
        return Z3Ast(ast: Z3_mk_int(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine unsigned
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger(value: UInt32) -> Z3Ast<UIntSort> {
        return Z3Ast(ast: Z3_mk_unsigned_int(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger64(value: Int64) -> Z3Ast<Int64Sort> {
        return Z3Ast(ast: Z3_mk_int64(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `UInt64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger64(value: UInt64) -> Z3Ast<UInt64Sort> {
        return Z3Ast(ast: Z3_mk_unsigned_int64(context, value, intSort().sort))
    }

    // MARK: - Bit-vectors

    /// Bitwise negation.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeBvNot<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvnot(context, t1.ast))
    }

    /// Take conjunction of bits in vector, return vector of length 1.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeBvRedAnd<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvredand(context, t1.ast))
    }

    /// Take disjunction of bits in vector, return vector of length 1.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeBvRedOr<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvredor(context, t1.ast))
    }

    /// Bitwise and.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvAnd<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvand(context, t1.ast, t2.ast))
    }

    /// Bitwise or.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvOr<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvor(context, t1.ast, t2.ast))
    }

    /// Bitwise exclusive-or.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvXor<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvxor(context, t1.ast, t2.ast))
    }

    /// Bitwise nand.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvNand<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvnand(context, t1.ast, t2.ast))
    }

    /// Bitwise nor.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvNor<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvnor(context, t1.ast, t2.ast))
    }

    /// Bitwise xnor.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvXnor<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvxnor(context, t1.ast, t2.ast))
    }

    /// Standard two's complement unary minus.
    ///
    /// The node `t1` must have bit-vector sort.
    public func makeBvNeg<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvneg(context, t1.ast))
    }

    /// Standard two's complement addition.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvAdd<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvadd(context, t1.ast, t2.ast))
    }

    /// Standard two's complement subtraction.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvSub<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvsub(context, t1.ast, t2.ast))
    }

    /// Standard two's complement multiplication.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvMul<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvmul(context, t1.ast, t2.ast))
    }

    /// Unsigned division.
    ///
    /// It is defined as the `floor` of `t1/t2` if `t2` is different from zero.
    /// If `t2` is zero, then the result is undefined.
    public func makeBvDiv<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvudiv(context, t1.ast, t2.ast))
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
    public func makeBvSDiv<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvsdiv(context, t1.ast, t2.ast))
    }
    
    /// Unsigned remainder.
    ///
    /// It is defined as `t1 - (t1 /u t2) * t2`, where `/u` represents unsigned
    /// division.
    ///
    /// If `t2` is zero, then the result is undefined.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvURem<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvurem(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed remainder (sign follows dividend).
    ///
    /// It is defined as `t1 - (t1 /s t2) * t2`, where `/s` represents signed division.
    /// The most significant bit (sign) of the result is equal to the most significant bit of `t1`.
    ///
    /// If `t2` is zero, then the result is undefined.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    ///
    /// - seealso: `makeBvSMod`
    public func makeBvSRem<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvsrem(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed remainder (sign follows divisor).
    ///
    /// If \ccode{t2} is zero, then the result is undefined.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// - seealso: `makeBvSRem`
    public func makeBvSMod<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvsmod(context, t1.ast, t2.ast))
    }
    
    /// Unsigned less than.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvUlt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvult(context, t1.ast, t2.ast))
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
    public func makeBvSlt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvslt(context, t1.ast, t2.ast))
    }
    
    /// Unsigned less than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvUle<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvule(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed less than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvSle<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvsle(context, t1.ast, t2.ast))
    }
    
    /// Unsigned greater than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvUge<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvuge(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed greater than or equal to.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvSge<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvsge(context, t1.ast, t2.ast))
    }
    
    /// Unsigned greater than.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvUgt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvugt(context, t1.ast, t2.ast))
    }
    
    /// Two's complement signed greater than.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvSgt<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_bvsgt(context, t1.ast, t2.ast))
    }
    
    /// Concatenate the given bit-vectors.
    ///
    /// The nodes `t1` and `t2` must have (possibly different) bit-vector sorts
    ///
    /// The result is a bit-vector of size `n1+n2`, where `n1` (`n2`)
    /// is the size of `t1` (`t2`).
    ///
    public func makeConcat<T: BitVectorSort, U: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<U>) -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_bvsgt(context, t1.ast, t2.ast))
    }
    
    /// Extract the bits `high` down to `low` from a bit-vector of
    /// size `m` to yield a new bit-vector of size `n`, where `n = high - low + 1`.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeExtract<T: BitVectorSort>(high: UInt32, low: UInt32, _ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_extract(context, high, low, t1.ast))
    }
    
    /// Sign-extend of the given bit-vector to the (signed) equivalent bit-vector
    /// of size `m+i`, where `m` is the size of the given bit-vector.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeSignExtend<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_sign_ext(context, i, t1.ast))
    }
    
    /// Extend the given bit-vector with zeros to the (unsigned) equivalent
    /// bit-vector of size `m+i`, where `m` is the size of the given bit-vector.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeZeroExtend<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_zero_ext(context, i, t1.ast))
    }
    
    /// Repeat the given bit-vector up length `i`.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeRepeat<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_repeat(context, i, t1.ast))
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
    public func makeBvShl<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_bvshl(context, t1.ast, t2.ast))
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
    public func makeBvLShr<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_bvlshr(context, t1.ast, t2.ast))
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
    public func makeBvAShr<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_bvashr(context, t1.ast, t2.ast))
    }
    
    /// Rotate bits of `t1` to the left `i` times.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeRotateLeft<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_rotate_left(context, i, t1.ast))
    }
    
    /// Rotate bits of `t1` to the right `i` times.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeRotateRight<T: BitVectorSort>(_ i: UInt32, _ t1: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_rotate_right(context, i, t1.ast))
    }
    
    /// Rotate bits of `t1` to the left `t2` times.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeExtRotateLeft<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_ext_rotate_left(context, t1.ast, t2.ast))
    }
    
    /// Rotate bits of `t1` to the right `t2` times.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeExtRotateRight<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast<T>(ast: Z3_mk_ext_rotate_right(context, t1.ast, t2.ast))
    }
    
    /// Create an `n` bit bit-vector from the integer argument `t1`.
    ///
    /// The resulting bit-vector has `n` bits, where the i'th bit (counting
    /// from 0 to `n-1`) is 1 if `(t1 div 2^i)` mod 2 is 1.
    ///
    /// The node `t1` must have integer sort.
    public func makeInt2BV<T: IntegralSort>(_ n: UInt32, _ t1: Z3Ast<T>) -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_int2bv(context, n, t1.ast))
    }
    
    /// Create a predicate that checks that the bit-wise addition of `t1` and
    /// `t2` does not overflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvAddNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvadd_no_overflow(context, t1.ast, t2.ast, isSigned))
    }
    
    /// Create a predicate that checks that the bit-wise addition of `t1` and
    /// `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvAddNoUnderflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvadd_no_underflow(context, t1.ast, t2.ast))
    }
    
    /// Create a predicate that checks that the bit-wise subtraction of `t1` and
    /// `t2` does not overflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvSubNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvsub_no_overflow(context, t1.ast, t2.ast))
    }
    
    /// Create a predicate that checks that the bit-wise subtraction of `t1` and
    /// `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvSubNoUnderflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvsub_no_underflow(context, t1.ast, t2.ast, isSigned))
    }
    
    /// Create a predicate that checks that the bit-wise signed division of `t1`
    /// and `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvSDivNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvsdiv_no_overflow(context, t1.ast, t2.ast))
    }
    
    /// Check that bit-wise negation does not overflow when `t1` is interpreted
    /// as a signed bit-vector.
    ///
    /// The node `t1` must have bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvNegNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvneg_no_overflow(context, t1.ast))
    }
    
    /// Create a predicate that checks that the bit-wise multiplication of `t1`
    /// and `t2` does not overflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvMulNoOverflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>, isSigned: Bool) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvmul_no_overflow(context, t1.ast, t2.ast, isSigned))
    }
    
    /// Create a predicate that checks that the bit-wise multiplication of `t1`
    /// and `t2` does not underflow.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    /// The returned node is of sort Bool.
    public func makeBvMulNoUnderflow<T: BitVectorSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_bvmul_no_underflow(context, t1.ast, t2.ast))
    }
}
