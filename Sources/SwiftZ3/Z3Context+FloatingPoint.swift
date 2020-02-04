import Z3

public extension Z3Context {
    // MARK: - Floating-Point Arighmetic
    
    /// Create the RoundingMode sort.
    func makeFpaRoundingModeSort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_fpa_rounding_mode_sort(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the
    /// NearestTiesToEven rounding mode.
    func makeFpaRoundNearestTiesToEven() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_round_nearest_ties_to_even(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the
    /// NearestTiesToEven rounding mode.
    func makeFpaRNE() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_rne(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the
    /// NearestTiesToAway rounding mode.
    func makeFpaRoundNearestTiesToAway() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_rne(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the
    /// NearestTiesToAway rounding mode.
    func makeFpaRNA() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_rna(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the TowardPositive
    /// rounding mode.
    func makeFpaRoundTowardPositive() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_round_toward_positive(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the TowardPositive
    /// rounding mode.
    func makeFpaRTP() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_rtp(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the TowardNegative
    /// rounding mode.
    func makeFpaRoundTowardNegative() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_round_toward_negative(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the TowardNegative
    /// rounding mode.
    func makeFpaRTN() -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_fpa_rtn(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the TowardZero
    /// rounding mode.
    func makeFpaRoundTowardZero() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_round_toward_zero(context))
    }
    
    /// Create a numeral of RoundingMode sort which represents the TowardZero
    /// rounding mode.
    func makeFpaRTZ() -> Z3Ast<RoundingMode> {
        return Z3Ast(ast: Z3_mk_fpa_rtz(context))
    }
    
    /// Create a FloatingPoint sort.
    ///
    /// - Parameter c: logical context
    /// - Parameter ebits: number of exponent bits
    /// - Parameter sbits: number of significand bits
    ///
    /// - remark: `ebits` must be larger than 1 and `sbits` must be larger than 2.
    func floatingPointSort(ebits: UInt32, sbits: UInt32) -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_fpa_sort(context, ebits, sbits))
    }
    
    /// Create the half-precision (16-bit) FloatingPoint sort.
    func floatingPoint16Sort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_fpa_sort_16(context))
    }

    /// Create the single-precision (32-bit) FloatingPoint sort.
    func floatingPoint32Sort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_fpa_sort_32(context))
    }
    
    /// Create the double-precision (32-bit) FloatingPoint sort.
    func floatingPoint64Sort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_fpa_sort_64(context))
    }
    
    /// Create the quadruple-precision (32-bit) FloatingPoint sort.
    func floatingPoint128Sort() -> Z3Sort {
        return Z3Sort(sort: Z3_mk_fpa_sort_128(context))
    }
    
    /// Create a floating-point NaN of sort `sort`.
    ///
    /// - Parameter sort: target sort
    func makeFpaNan<T: FloatingSort>(sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_nan(context, T.getSort(self).sort))
    }
    
    /// Create a floating-point infinity of sort `sort`.
    ///
    /// When `negative` is `true`, -oo will be generated instead of +oo.
    ///
    /// - Parameter sort: target sort
    /// - Parameter negative: indicates whether the result should be negative
    func makeFpaInfinite<T: FloatingSort>(sort: T.Type, negative: Bool) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_nan(context, T.getSort(self).sort))
    }
    
    /// Create a floating-point zero of sort `sort`.
    ///
    /// When `negative` is `true`, -zero will be generated instead of +zero.
    ///
    /// - Parameter sort: target sort
    /// - Parameter negative: indicates whether the result should be negative
    func makeFpaZero<T: FloatingSort>(sort: T.Type, negative: Bool) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_nan(context, T.getSort(self).sort))
    }
    
    /// Create an expression of FloatingPoint sort from three bit-vector expressions.
    ///
    /// This is the operator named `fp' in the SMT FP theory definition.
    /// Note that `sgn` is required to be a bit-vector of size 1. Significand
    /// and exponent are required to be longer than 1 and 2 respectively. The
    /// FloatingPoint sort of the resulting expression is automatically determined
    /// from the bit-vector sizes of the arguments. The exponent is assumed to
    /// be in IEEE-754 biased representation.
    /// - Parameters:
    ///   - sgn: sign
    ///   - exp: exponen
    ///   - sig: significand
    func makeFpaFp<T: BitVectorSort, U: BitVectorSort, V: BitVectorSort>(sgn: Z3Ast<T>, exp: Z3Ast<U>, sig: Z3Ast<V>) -> AnyZ3Ast {
        return AnyZ3Ast(ast: Z3_mk_fpa_fp(context, sgn.ast, exp.ast, sig.ast))
    }
    
    /// Create a numeral of FloatingPoint sort from a float.
    ///
    /// This function is used to create numerals that fit in a float value.
    /// It is slightly faster than `makeNumeral` since it is not necessary to
    /// parse a string.
    ///
    /// - Parameters:
    ///   - value: value
    ///   - sort: sort
    func makeFpaNumeralFloat<T: FloatingSort>(_ value: Float, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_numeral_float(context, value, sort.getSort(self).sort))
    }
    
    /// Create a numeral of FloatingPoint sort from a double.
    ///
    /// This function is used to create numerals that fit in a float value.
    /// It is slightly faster than `makeNumeral` since it is not necessary to
    /// parse a string.
    ///
    /// - Parameters:
    ///   - value: value
    ///   - sort: sort
    func makeFpaNumeralDouble<T: FloatingSort>(_ value: Double, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_numeral_double(context, value, sort.getSort(self).sort))
    }
    
    /// Create a numeral of FloatingPoint sort from a signed integer.
    ///
    /// - Parameters:
    ///   - value: value
    ///   - sort: result sort
    func makeFpaNumeralInt<T: FloatingSort>(_ value: Int32, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_numeral_int(context, value, sort.getSort(self).sort))
    }
    
    /// Create a numeral of FloatingPoint sort from a sign bit and two integers.
    ///
    /// - Parameters:
    ///   - sgn: sign bit (true == negative)
    ///   - exp: exponent
    ///   - sig: significand
    ///   - sort: result sort
    func makeFpaNumeralUInt<T: FloatingSort>(_ sgn: Bool, _ exp: Int32, _ sig: UInt32, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_numeral_int_uint(context, sgn, exp, sig, sort.getSort(self).sort))
    }
    
    /// Create a numeral of FloatingPoint sort from a sign bit and two 64-bit
    /// integers.
    ///
    /// - Parameters:
    ///   - sgn: sign bit (true == negative)
    ///   - exp: exponent
    ///   - sig: significand
    ///   - sort: result sort
    func makeFpaNumeralUInt<T: FloatingSort>(_ sgn: Bool, _ exp: Int64, _ sig: UInt64, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_numeral_int64_uint64(context, sgn, exp, sig, sort.getSort(self).sort))
    }
    
    /// Floating-point absolute value
    func makeFpaAbs<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_abs(context, t.ast))
    }
    
    /// Floating-point negation
    func makeFpaNeg<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_neg(context, t.ast))
    }
    
    /// Floating-point addition
    ///
    /// `rm` must be of RoundingMode sort, `t1` and `t2` must have the same
    /// FloatingPoint sort.
    ///
    /// - Parameters:
    ///   - rm: term of RoundingMode sort
    func makeFpaAdd<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                     _ t1: Z3Ast<T>,
                                     _ t2: Z3Ast<T>) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_add(context, rm.ast, t1.ast, t2.ast))
    }
    
    /// Floating-point subtraction
    ///
    /// `rm` must be of RoundingMode sort, `t1` and `t2` must have the same
    /// FloatingPoint sort.
    ///
    /// - Parameters:
    ///   - rm: term of RoundingMode sort
    func makeFpaSubtract<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                     _ t1: Z3Ast<T>,
                                     _ t2: Z3Ast<T>) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_sub(context, rm.ast, t1.ast, t2.ast))
    }
    
    /// Floating-point multiplication
    ///
    /// `rm` must be of RoundingMode sort, `t1` and `t2` must have the same
    /// FloatingPoint sort.
    ///
    /// - Parameters:
    ///   - rm: term of RoundingMode sort
    func makeFpaMultiply<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                     _ t1: Z3Ast<T>,
                                     _ t2: Z3Ast<T>) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_mul(context, rm.ast, t1.ast, t2.ast))
    }
    
    /// Floating-point division
    ///
    /// `rm` must be of RoundingMode sort, `t1` and `t2` must have the same
    /// FloatingPoint sort.
    ///
    /// - Parameters:
    ///   - rm: term of RoundingMode sort
    func makeFpaDivide<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                        _ t1: Z3Ast<T>,
                                        _ t2: Z3Ast<T>) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_div(context, rm.ast, t1.ast, t2.ast))
    }
    
    /// Floating-point fused multiply-add.
    ///
    /// The result is `round((t1 * t2) + t3)`.
    ///
    /// `rm` must be of RoundingMode sort, `t1`, `t2`, and `t3` must have the
    /// same FloatingPoint sort.
    ///
    /// - Parameters:
    ///   - rm: term of RoundingMode sort
    func makeFpaDivide<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                        _ t1: Z3Ast<T>,
                                        _ t2: Z3Ast<T>,
                                        _ t3: Z3Ast<T>) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_fma(context, rm.ast, t1.ast, t2.ast, t3.ast))
    }
    
    /// Floating-point square root
    func makeFpaSquareRoot<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                            _ t1: Z3Ast<T>) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_sqrt(context, rm.ast, t1.ast))
    }
    
    /// Floating-point remainder
    func makeFpaRemainder<T: FloatingSort>(_ t1: Z3Ast<T>,
                                           _ t2: Z3Ast<T>) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_rem(context, t1.ast, t2.ast))
    }
    
    /// Floating-point roundToIntegral. Rounds a floating-point number to
    /// the closest integer, again represented as a floating-point number.
    func makeFpaRoundToIntegral<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                                 _ t: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_round_to_integral(context, rm.ast, t.ast))
    }
    
    /// Minimum of floating-point numbers.
    func makeFpaMin<T: FloatingSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_min(context, t1.ast, t2.ast))
    }
    
    /// Maximum of floating-point numbers.
    func makeFpaMax<T: FloatingSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_fpa_max(context, t1.ast, t2.ast))
    }
    
    /// Floating-point less than or equal.
    func makeFpaLeq<T: FloatingSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_leq(context, t1.ast, t2.ast))
    }
    
    /// Floating-point less than.
    func makeFpaLt<T: FloatingSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_lt(context, t1.ast, t2.ast))
    }
    
    /// Floating-point greater than or equal.
    func makeFpaGeq<T: FloatingSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_geq(context, t1.ast, t2.ast))
    }
    
    /// Floating-point greater than.
    func makeFpaGt<T: FloatingSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_gt(context, t1.ast, t2.ast))
    }
    
    /// Floating-point equality.
    func makeFpaEq<T: FloatingSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_eq(context, t1.ast, t2.ast))
    }
    
    /// Predicate indicating whether `t` is a normal floating-point number.
    func makeFpaIsNormal<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_is_normal(context, t.ast))
    }
    
    /// Predicate indicating whether `t` is a subnormal floating-point number.
    func makeFpaIsSubnormal<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_is_subnormal(context, t.ast))
    }
    
    /// Predicate indicating whether `t` is a floating-point number with zero
    /// value, i.e., +zero or -zero.
    func makeFpaIsZero<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_is_zero(context, t.ast))
    }
    
    /// Predicate indicating whether `t` is a floating-point number representing
    /// +oo or -oo.
    func makeFpaIsInfinite<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_is_infinite(context, t.ast))
    }
    
    /// Predicate indicating whether `t` is a NaN.
    func makeFpaIsNan<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_is_nan(context, t.ast))
    }
    
    /// Predicate indicating whether `t` is a negative floating-point number.
    func makeFpaIsNegative<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_is_negative(context, t.ast))
    }
    
    /// Predicate indicating whether `t` is a positive floating-point number.
    func makeFpaIsPositive<T: FloatingSort>(_ t: Z3Ast<T>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_fpa_is_positive(context, t.ast))
    }
    
    /// Conversion of a single IEEE 754-2008 bit-vector into a floating-point number.
    ///
    /// Produces a term that represents the conversion of a bit-vector term `bv`
    /// to a floating-point term of sort `sort`.
    ///
    /// `sort` must be a FloatingPoint sort, `t` must be of bit-vector sort, and
    /// the bit-vector size of `bv` must be equal to `ebits+sbits` of `sort`. The
    /// format of the bit-vector is as defined by the IEEE 754-2008 interchange
    /// format.
    ///
    /// - Parameters:
    ///   - bv: a bit-vector term
    ///   - sort: floating-point sort
    func makeFpaToFPBv<T: BitVectorSort, U: FloatingSort>(_ bv: Z3Ast<T>, sort: U.Type) -> Z3Ast<U> {
        return Z3Ast(ast: Z3_mk_fpa_to_fp_bv(context, bv.ast, sort.getSort(self).sort))
    }
    
    /// Conversion of a FloatingPoint term into another term of different
    /// FloatingPoint sort.
    ///
    /// Produces a term that represents the conversion of a floating-point term
    /// `t` to a floating-point term of sort `sort`. If necessary, the result will
    /// be rounded according to rounding mode `rm`.
    ///
    /// - Parameters:
    ///   - bv: a bit-vector term
    ///   - sort: floating-point sort
    func makeFpaToFPFloat<T: FloatingSort, U: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                                            _ t: Z3Ast<T>,
                                                            sort: U.Type) -> Z3Ast<U> {
        
        return Z3Ast(ast: Z3_mk_fpa_to_fp_float(context, rm.ast, t.ast, sort.getSort(self).sort))
    }
    
    /// Conversion of a term of real sort into a term of FloatingPoint sort.
    ///
    /// Produces a term that represents the conversion of term `t` of real sort
    /// into a floating-point term of sort `sort`. If necessary, the result will
    /// be rounded according to rounding mode `rm`.
    func makeFpaToFPReal<T: FloatingSort>(_ rm: Z3Ast<RoundingMode>,
                                          _ t: Z3Ast<RealSort>,
                                          sort: T.Type) -> Z3Ast<T> {
        
        return Z3Ast(ast: Z3_mk_fpa_to_fp_real(context, rm.ast, t.ast, sort.getSort(self).sort))
    }
}
