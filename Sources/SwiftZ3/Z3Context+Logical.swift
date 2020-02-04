import Z3

public extension Z3Context {
    // MARK: - Propositional Logic and Equality

    /// Create an AST node representing `true`.
    func makeTrue() -> Z3Ast<Bool> {
        return Z3Ast(context: self, ast: Z3_mk_true(context))
    }

    /// Create an AST node representing `false`.
    func makeFalse() -> Z3Ast<Bool> {
        return Z3Ast(context: self, ast: Z3_mk_false(context))
    }

    /// Create an AST node representing `l = r`.
    ///
    /// The nodes `l` and `r` must have the same type.
    func makeEqual<T>(_ l: Z3Ast<T>, _ r: Z3Ast<T>) -> Z3Ast<Bool> {
        return Z3Ast(context: self, ast: Z3_mk_eq(context, l.ast, r.ast))
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
    func makeDistinct<T>(_ args: [Z3Ast<T>]) -> Z3Ast<Bool> {
        precondition(args.count > 1)
        return preparingArgsAst(args) { (count, args) -> Z3Ast<Bool> in
            Z3Ast(context: self, ast: Z3_mk_distinct(context, count, args))
        }
    }

    /// Create an AST node representing `not(a)`.
    ///
    /// The node `a` must have Boolean sort.
    func makeNot(_ a: Z3Ast<Bool>) -> Z3Ast<Bool> {
        return Z3Ast(context: self, ast: Z3_mk_not(context, a.ast))
    }

    /// Create an AST node representing an if-then-else: `ite(t1, t2, t3)`.
    ///
    /// The node `t1` must have Boolean sort, `t2` and `t3` must have the same
    /// sort.
    /// The sort of the new node is equal to the sort of `t2` and `t3`.
    func makeIfThenElse<T>(_ t1: Z3Ast<Bool>, _ t2: Z3Ast<T>, _ t3: Z3Ast<T>) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_ite(context, t1.ast, t2.ast, t2.ast))
    }

    /// Create an AST node representing `t1 iff t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    func makeIff(_ t1: Z3Ast<Bool>, _ t2: Z3Ast<Bool>) -> Z3Ast<Bool> {
        return Z3Ast(context: self, ast: Z3_mk_iff(context, t1.ast, t2.ast))
    }

    /// Create an AST node representing `t1 implies t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    func makeImplies(_ t1: Z3Ast<Bool>, _ t2: Z3Ast<Bool>) -> Z3Ast<Bool> {
        return Z3Ast(context: self, ast: Z3_mk_implies(context, t1.ast, t2.ast))
    }

    /// Create an AST node representing `t1 xor t2`.
    ///
    /// The nodes `t1` and `t2` must have Boolean sort.
    func makeXor(_ t1: Z3Ast<Bool>, _ t2: Z3Ast<Bool>) -> Z3Ast<Bool> {
        return Z3Ast(context: self, ast: Z3_mk_xor(context, t1.ast, t2.ast))
    }

    /// Create an AST node representing `args[0] and ... and args[num_args-1]`.
    ///
    /// All arguments must have Boolean sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    func makeAnd(_ args: [Z3Ast<Bool>]) -> Z3Ast<Bool> {
        return preparingArgsAst(args) { (count, args) -> Z3Ast<Bool> in
            return Z3Ast(context: self, ast: Z3_mk_and(context, count, args))
        }
    }

    /// Create an AST node representing `args[0] or ... or args[num_args-1]`.
    ///
    /// All arguments must have Boolean sort.
    ///
    /// - remark: The number of arguments must be greater than zero.
    func makeOr(_ args: [Z3Ast<Bool>]) -> Z3Ast<Bool> {
        return preparingArgsAst(args) { (count, args) -> Z3Ast<Bool> in
            return Z3Ast(context: self, ast: Z3_mk_or(context, count, args))
        }
    }
}
