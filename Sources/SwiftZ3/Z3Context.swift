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

    // MARK: - Propositional Logic and Equality

    /// Create an AST node representing `true`.
    public func makeTrue() -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_true(context))
    }

    /// Create an AST node representing `false`.
    public func makeFalse() -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_false(context))
    }

    /// Create an AST node representing `l = r`.
    ///
    /// The nodes `l` and `r` must have the same type.
    public func makeEqual<T>(_ l: Z3Ast<T>, _ r: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_eq(context, l.ast, r.ast))
    }

    /// Create an AST node representing `distinct(args[0], ..., args[num_args-1])`.
    ///
    /// The `distinct` construct is used for declaring the arguments pairwise
    /// distinct.
    /// That is, `Forall 0 <= i < j < num_args. not args[i] = args[j]`.
    ///
    /// All arguments must have the same sort.
    ///
    /// - remark: The number of arguments of a distinct construct must be greater
    ///  than one.
    public func makeDistinct<T>(_ args: [Z3Ast<T>]) -> Z3Ast<T> {
        precondition(args.count > 1)
        return preparingArgsAst(args) { (count, args) -> Z3Ast<T> in
            Z3Ast(ast: Z3_mk_distinct(context, count, args))
        }
    }

    /// Create an AST node representing `not(a)`.
    ///
    /// The node `a` must have Boolean sort.
    public func makeNot(_ a: Z3Ast<BoolSort>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_not(context, a.ast))
    }

    /// Create an AST node representing an if-then-else: `ite(t1, t2, t3)`.
    ///
    /// The node `t1` must have Boolean sort, `t2` and `t3` must have the same
    /// sort.
    /// The sort of the new node is equal to the sort of `t2` and `t3`.
    public func makeIfThenElse<T>(_ t1: Z3Ast<BoolSort>, _ t2: Z3Ast<T>, _ t3: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_ite(context, t1.ast, t2.ast, t2.ast))
    }

    /// Create an AST node representing `t1 iff t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    public func makeIff(_ t1: Z3Ast<BoolSort>, _ t2: Z3Ast<BoolSort>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_iff(context, t1.ast, t2.ast))
    }

    /// Create an AST node representing `t1 implies t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    public func makeImplies(_ t1: Z3Ast<BoolSort>, _ t2: Z3Ast<BoolSort>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_implies(context, t1.ast, t2.ast))
    }

    /// Create an AST node representing `t1 xor t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    public func makeXor(_ t1: Z3Ast<BoolSort>, _ t2: Z3Ast<BoolSort>) -> Z3Ast<BoolSort> {
        return Z3Ast(ast: Z3_mk_xor(context, t1.ast, t2.ast))
    }

    /// Create an AST node representing `args[0] and ... and args[num_args-1]`.
    ///
    /// All arguments must have Boolean sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeAnd(_ args: [Z3Ast<BoolSort>]) -> Z3Ast<BoolSort> {
        return preparingArgsAst(args) { (count, args) -> Z3Ast<BoolSort> in
            return Z3Ast(ast: Z3_mk_and(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] or ... or args[num_args-1]`.
    ///
    /// All arguments must have Boolean sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeOr(_ args: [Z3Ast<BoolSort>]) -> Z3Ast<BoolSort> {
        return preparingArgsAst(args) { (count, args) -> Z3Ast<BoolSort> in
            return Z3Ast(ast: Z3_mk_or(context, count, args))
        }
    }

    // MARK: - Integers and Reals

    /// Create an AST node representing `args[0] + ... + args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeAdd<T: NumericalSort>(_ arguments: [Z3Ast<T>]) -> Z3Ast<T> {
        return preparingArgsAst(arguments) { count, args in
            Z3Ast(ast: Z3_mk_add(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] * ... * args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: Z3 has limited support for non-linear arithmetic.
    /// - remark: The number of arguments must be greater than zero.
    public func makeMul<T: NumericalSort>(_ arguments: [Z3Ast<T>]) -> Z3Ast<T> {
        precondition(!arguments.isEmpty)
        
        return preparingArgsAst(arguments) { count, args in
            Z3Ast(ast: Z3_mk_mul(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] + ... + args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeSub<T: NumericalSort>(_ arguments: [Z3Ast<T>]) -> Z3Ast<T> {
        precondition(!arguments.isEmpty)

        return preparingArgsAst(arguments) { count, args in
            Z3Ast(ast: Z3_mk_sub(context, count, args))
        }
    }

    /// Create an AST node representing `- arg`.
    /// The arguments must have int or real type.
    public func makeUnaryMinus<T: NumericalSort>(_ ast: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_unary_minus(context, ast.ast))
    }

    /// Create an AST node representing `arg1 div arg2`.
    ///
    /// The arguments must either both have int type or both have real type.
    /// If the arguments have int type, then the result type is an int type,
    /// otherwise the the result type is real.
    public func makeDiv<T: NumericalSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_div(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 mod arg2`.
    ///
    /// The arguments must have int type.
    public func makeMod<T: IntegralSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_mod(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 rem arg2`.
    ///
    /// The arguments must have int type.
    public func makeRem<T: IntegralSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_rem(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 ^ arg2`.
    ///
    /// The arguments must have int or real type.
    public func makePower<T: NumericalSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_power(context, arg1.ast, arg2.ast))
    }

    /// Create less than.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeLessThan<T: NumericalSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_lt(context, t1.ast, t2.ast))
    }

    /// Create less than or equal to.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeLessThanOrEqualTo<T: NumericalSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_le(context, t1.ast, t2.ast))
    }

    /// Create greater than.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeGreaterThan<T: NumericalSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_gt(context, t1.ast, t2.ast))
    }

    /// Create greater than or equal to.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeGreaterThanOrEqualTo<T: NumericalSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_ge(context, t1.ast, t2.ast))
    }

    /// Create division predicate.
    ///
    /// The nodes `t1` and `t2` must be of integer sort.
    /// The predicate is true when `t1` divides `t2`. For the predicate to be
    /// part of linear integer arithmetic, the first argument `t1` must be a
    /// non-zero integer.
    public func makeDivides<T: IntegralSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(ast: Z3_mk_divides(context, t1.ast, t2.ast))
    }

    /// MARK: - Bit-vectors

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
}
