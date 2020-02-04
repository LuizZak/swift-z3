import CZ3

public extension Z3Context {    
    // MARK: - Integers and Reals

    /// Create an AST node representing `args[0] + ... + args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    func makeAdd<T: IntOrRealSort>(_ arguments: [Z3Ast<T>]) -> Z3Ast<T> {
        return preparingArgsAst(arguments) { count, args in
            Z3Ast(context: self, ast: Z3_mk_add(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] * ... * args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: Z3 has limited support for non-linear arithmetic.
    /// - remark: The number of arguments must be greater than zero.
    func makeMul<T: IntOrRealSort>(_ arguments: [Z3Ast<T>]) -> Z3Ast<T> {
        precondition(!arguments.isEmpty)
        
        return preparingArgsAst(arguments) { count, args in
            Z3Ast(context: self, ast: Z3_mk_mul(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] + ... + args[num_args-1]`.
    ///
    /// All arguments must have int or real sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    func makeSub<T: IntOrRealSort>(_ arguments: [Z3Ast<T>]) -> Z3Ast<T> {
        precondition(!arguments.isEmpty)

        return preparingArgsAst(arguments) { count, args in
            Z3Ast(context: self, ast: Z3_mk_sub(context, count, args))
        }
    }

    /// Create an AST node representing `- arg`.
    /// The arguments must have int or real type.
    func makeUnaryMinus<T: IntOrRealSort>(_ ast: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_unary_minus(context, ast.ast))
    }

    /// Create an AST node representing `arg1 div arg2`.
    ///
    /// The arguments must either both have int type or both have real type.
    /// If the arguments have int type, then the result type is an int type,
    /// otherwise the the result type is real.
    func makeDiv<T: IntOrRealSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_div(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 mod arg2`.
    ///
    /// The arguments must have int type.
    func makeMod<T: IntegralSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_mod(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 rem arg2`.
    ///
    /// The arguments must have int type.
    func makeRem<T: IntegralSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_rem(context, arg1.ast, arg2.ast))
    }

    /// Create an AST node representing `arg1 ^ arg2`.
    ///
    /// The arguments must have int or real type.
    func makePower<T: IntOrRealSort>(_ arg1: Z3Ast<T>, _ arg2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_power(context, arg1.ast, arg2.ast))
    }

    /// Create less than.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    func makeLessThan<T: IntOrRealSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_lt(context, t1.ast, t2.ast))
    }

    /// Create less than or equal to.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    func makeLessThanOrEqualTo<T: IntOrRealSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_le(context, t1.ast, t2.ast))
    }

    /// Create greater than.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    func makeGreaterThan<T: IntOrRealSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_gt(context, t1.ast, t2.ast))
    }

    /// Create greater than or equal to.
    /// The nodes `t1` and `t2` must have the same sort, and must be int or real.
    func makeGreaterThanOrEqualTo<T: IntOrRealSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_ge(context, t1.ast, t2.ast))
    }

    /// Create division predicate.
    ///
    /// The nodes `t1` and `t2` must be of integer sort.
    /// The predicate is true when `t1` divides `t2`. For the predicate to be
    /// part of linear integer arithmetic, the first argument `t1` must be a
    /// non-zero integer.
    func makeDivides<T: IntegralSort>(_ t1: Z3Ast<T>, _ t2: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_divides(context, t1.ast, t2.ast))
    }

    /// Coerce an integer to a real.
    ///
    /// There is also a converse operation exposed.
    /// It follows the semantics prescribed by the SMT-LIB standard.
    ///
    /// You can take the floor of a real by creating an auxiliary integer constant
    /// `k` and and asserting `mk_int2real(k) <= t1 < mk_int2real(k)+1`.
    ///
    /// The node `t1` must have sort integer.
    ///
    /// - seealso: `makeReal2Int`
    /// - seealso: `makeIsInt`
    func makeInt2Real<T: IntegralSort>(_ t1: Z3Ast<T>) -> Z3Ast<RealSort> {
        return Z3Ast(context: self, ast: Z3_mk_int2real(context, t1.ast))
    }

    /// Check if a real number is an integer.
    ///
    /// - seealso: `makeInt2Real`
    /// - seealso: `makeReal2Int`
    func makeIsInt(_ t1: Z3Ast<RealSort>) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_is_int(context, t1.ast))
    }
}
