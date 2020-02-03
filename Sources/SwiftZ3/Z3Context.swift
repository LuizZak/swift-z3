import Z3

public class Z3Context {
    internal var context: Z3_context

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context(configuration?.config)
    }

    deinit {
        Z3_del_context(context)
    }

    /// Declare and create a constant.
    ///
    /// This function is a shorthand for:
    /// ```
    /// Z3_func_decl d = Z3_mk_func_decl(c, s, 0, 0, ty);
    /// Z3_ast n       = Z3_mk_app(c, d, 0, 0);
    /// ```
    public func makeConstant(name: String, sort: Z3Sort) -> Z3Ast {
        let symbol = Z3_mk_string_symbol(context, name)

        return Z3Ast(ast: Z3_mk_const(context, symbol, sort.sort))
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
    public func makeNumeral(number: String, sort: Z3Sort) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_numeral(context, number, sort.sort))
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
    public func makeUnsignedInteger(value: UInt32) -> Z3Ast<RealSort> {
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
    public func makeInteger64(value: Int64) -> Z3Ast<RealSort> {
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

    // MARK: - Propositional Logic and Equality

    /// Create an AST node representing `true`.
    public func makeTrue() -> Z3Ast {
        return Z3Ast(ast: Z3_mk_true(context))
    }

    /// Create an AST node representing `false`.
    public func makeFalse() -> Z3Ast {
        return Z3Ast(ast: Z3_mk_false(context))
    }

    /// Create an AST node representing `l = r`.
    ///
    /// The nodes `l` and `r` must have the same type.
    public func makeEqual(_ l: Z3Ast, _ r: Z3Ast) -> Z3Ast {
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
    public func makeDistinct(_ args: [Z3Ast]) -> Z3Ast {
        precondition(args.count > 1)
        return preparingArgsAst(args) { (count, args) -> Z3Ast in
            Z3Ast(ast: Z3_mk_distinct(context, count, args))
        }
    }

    /// Create an AST node representing `not(a)`.
    ///
    /// The node `a` must have Boolean sort.
    public func makeNot(_ a: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_not(context, a))
    }

    /// Create an AST node representing an if-then-else: `ite(t1, t2, t3)`.
    ///
    /// The node `t1` must have Boolean sort, `t2` and `t3` must have the same
    /// sort.
    /// The sort of the new node is equal to the sort of `t2` and `t3`.
    public func makeIfThenElse(_ t1: Z3Ast, _ t2: Z3Ast, _ t3: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_ite(context, t1, t2, t2))
    }

    /// Create an AST node representing `t1 iff t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    public func makeIff(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_iff(context, t1, t2))
    }

    /// Create an AST node representing `t1 implies t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    public func makeImplies(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_implies(context, t1, t2))
    }

    /// Create an AST node representing `t1 xor t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    public func makeXor(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_xor(context, t1, t2))
    }

    /// Create an AST node representing `args[0] and ... and args[num_args-1]`.
    ///
    /// All arguments must have Boolean sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeAnd(_ args: [Z3Ast]) -> Z3Ast {
        return preparingArgsAst(args) { (count, args) -> Z3Ast in
            return Z3Ast(ast: Z3_mk_and(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] or ... or args[num_args-1]`.
    ///
    /// All arguments must have Boolean sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeOr(_ args: [Z3Ast]) -> Z3Ast {
        return preparingArgsAst(args) { (count, args) -> Z3Ast in
            return Z3Ast(ast: Z3_mk_or(context, count, args))
        }
    }

    // MARK: - Integers and Reals

    /// Create an AST node representing `args[0] + ... + args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeAdd(_ arguments: [Z3Ast]) -> Z3Ast {
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
    public func makeMul(_ arguments: [Z3Ast]) -> Z3Ast {
        precondition(!arguments.isEmpty)
        let arguments: [Z3_ast?] = arguments.map { $0.ast }

        return preparingArgsAst(arguments) { count, args in
            Z3Ast(ast: Z3_mk_mul(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] + ... + args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    public func makeSub(_ arguments: [Z3Ast]) -> Z3Ast {
        precondition(!arguments.isEmpty)

        return preparingArgsAst(arguments) { count, args in
            Z3Ast(ast: Z3_mk_sub(context, count, args))
        }
    }

    /// Create an AST node representing `- arg`.
    /// The arguments must have int or real type.
    public func makeUnaryMinus(_ ast: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_unary_minus(context, ast.ast))
    }

    /// Create an AST node representing `arg1 div arg2`.
    ///
    /// The arguments must either both have int type or both have real type.
    /// If the arguments have int type, then the result type is an int type,
    /// otherwise the the result type is real.
    public func makeDiv(_ arg1: Z3Ast, _ arg2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_div(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 mod arg2`.
    ///
    /// The arguments must have int type.
    public func makeMod(_ arg1: Z3Ast, _ arg2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_mod(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 rem arg2`.
    ///
    /// The arguments must have int type.
    public func makeRem(_ arg1: Z3Ast, _ arg2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_rem(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 ^ arg2`.
    ///
    /// The arguments must have int or real type.
    public func makePower(_ arg1: Z3Ast, _ arg2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_power(context, arg1.ast, arg2.ast))
    }

    /// Create less than.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeLessThan(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_lt(context, t1, t2))
    }

    /// Create less than or equal to.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeLessThanOrEqualTo(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_le(context, t1, t2))
    }

    /// Create greater than.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeGreaterThan(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_gt(context, t1, t2))
    }

    /// Create greater than or equal to.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    public func makeGreaterThanOrEqualTo(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_ge(context, t1, t2))
    }

    /// Create division predicate.
    ///
    /// The nodes `t1` and `t2` must be of integer sort.
    /// The predicate is true when `t1` divides `t2`. For the predicate to be
    /// part of linear integer arithmetic, the first argument `t1` must be a
    /// non-zero integer.
    public func makeDivides(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_divides(context, t1, t2))
    }

    /// MARK: - Bit-vectors

    /// Bitwise negation.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeBvNot(_ t1: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvnot(context, t1))
    }

    /// Take conjunction of bits in vector, return vector of length 1.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeBvRedAnd(_ t1: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvredand(context, t1))
    }

    /// Take disjunction of bits in vector, return vector of length 1.
    ///
    /// The node `t1` must have a bit-vector sort.
    public func makeBvRedOr(_ t1: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvredor(context, t1))
    }

    /// Bitwise and.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvAnd(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvand(context, t1, t2))
    }

    /// Bitwise or.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvOr(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvor(context, t1, t2))
    }

    /// Bitwise exclusive-or.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvXor(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvxor(context, t1, t2))
    }

    /// Bitwise nand.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvNand(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvnand(context, t1, t2))
    }

    /// Bitwise nor.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvNor(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvnor(context, t1, t2))
    }

    /// Bitwise xnor.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvXnor(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvxnor(context, t1, t2))
    }

    /// Standard two's complement unary minus.
    ///
    /// The node `t1` must have bit-vector sort.
    public func makeBvNeg(_ t1: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvneg(context, t1))
    }

    /// Standard two's complement addition.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvAdd(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvadd(context, t1, t2))
    }

    /// Standard two's complement subtraction.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvSub(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvsub(context, t1, t2))
    }

    /// Standard two's complement multiplication.
    ///
    /// The nodes `t1` and `t2` must have the same bit-vector sort.
    public func makeBvMul(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvmul(context, t1, t2))
    }

    /// Unsigned division.
    ///
    /// It is defined as the `floor` of `t1/t2` if `t2` is different from zero.
    /// If `t2` is zero, then the result is undefined.
    public func makeBvDiv(_ t1: Z3Ast, _ t2: Z3Ast) -> Z3Ast {
        return Z3Ast(ast: Z3_mk_bvudiv(context, t1, t2))
    }

    private func preparingArgsAst<T>(_ arguments: [Z3Ast], _ closure: (UInt32, UnsafePointer<Z3_ast?>) -> T) -> T {
        let arguments: [Z3_ast?] = arguments.map { $0.ast }
        return closure(UInt32(arguments.count), arguments)
    }

    // MARK: -
}
