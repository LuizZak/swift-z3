import Z3

public class Z3Optimize {
    var context: Z3Context
    var optimize: Z3_optimize

    init(context: Z3Context, optimize: Z3_optimize) {
        self.context = context
        self.optimize = optimize

        Z3_optimize_inc_ref(context.context, optimize)
    }

    deinit {
        Z3_optimize_dec_ref(context.context, optimize)
    }

    /// Assert hard constraint to the optimization context.
    public func assert(_ a: Z3Bool) {
        Z3_optimize_assert(context.context, optimize, a.ast)
    }

    /// Assert soft constraint to the optimization context.
    ///
    /// - parameter a: formula
    /// - parameter weight: a positive weight, penalty for violating soft constraint
    /// - parameter id: optional identifier to group soft constraints
    public func assertSoft(_ a: Z3Bool, weight: String, id: Z3Symbol) -> UInt32 {
        return Z3_optimize_assert_soft(context.context, optimize, a.ast, weight, id.symbol)
    }

    /// Add a maximization constraint.
    ///
    /// - seealso: `minimize()`
    public func maximize<T: BitVectorSort>(_ a: Z3Ast<T>) -> UInt32 {
        return Z3_optimize_maximize(context.context, optimize, a.ast)
    }

    /// Add a maximization constraint.
    ///
    /// - seealso: `minimize()`
    public func maximize<T: IntOrRealSort>(_ a: Z3Ast<T>) -> UInt32 {
        return Z3_optimize_maximize(context.context, optimize, a.ast)
    }

    /// Add a minimization constraint.
    ///
    /// - seealso: `maximize()`
    public func minimize<T: BitVectorSort>(_ a: Z3Ast<T>) -> UInt32 {
        return Z3_optimize_minimize(context.context, optimize, a.ast)
    }

    /// Add a minimization constraint.
    ///
    /// - seealso: `maximize()`
    public func minimize<T: IntOrRealSort>(_ a: Z3Ast<T>) -> UInt32 {
        return Z3_optimize_minimize(context.context, optimize, a.ast)
    }

    /// Create a backtracking point.
    ///
    /// The optimize solver contains a set of rules, added facts and assertions.
    /// The set of rules, facts and assertions are restored upon calling `pop()`.
    ///
    /// - seealso: `pop()`
    public func push() {

    }

    /// Backtrack one level.
    ///
    /// - precondition: The number of calls to pop cannot exceed calls to push.
    /// - seealso: `push`
    public func pop() {

    }
}
