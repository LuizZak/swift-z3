import CZ3

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
    ///
    /// - seealso: `assertSoft`
    /// - seealso: `assertAndTrack`
    public func assert(_ a: Z3Bool) {
        Z3_optimize_assert(context.context, optimize, a.ast)
    }

    /// Assert tracked hard constraint to the optimization context.
    ///
    /// - seealso: `assert`
    /// - seealso: `assertSoft`
    public func assertAndTrack(_ a: Z3Bool, _ t: Z3Bool) {
        Z3_optimize_assert_and_track(context.context, optimize, a.ast, t.ast)
    }

    /// Assert soft constraint to the optimization context.
    ///
    /// - parameter a: formula
    /// - parameter weight: a positive weight, penalty for violating soft constraint
    /// - parameter id: optional identifier to group soft constraints
    /// - seealso: `assert`
    /// - seealso: `assertAndTrack`
    public func assertSoft(_ a: Z3Bool, weight: String, id: Z3Symbol? = nil) -> UInt32 {
        return Z3_optimize_assert_soft(context.context, optimize, a.ast, weight, id?.symbol)
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

    /// Check consistency and produce optimal values.
    ///
    /// - parameter assumptions: the additional assumptions
    /// - seealso: `getReasonUnkown`
    /// - seealso: `getModel`
    /// - seealso: `getStatistics`
    /// - seealso: `getUnsatCore`
    public func check(_ assumptions: [AnyZ3Ast] = []) -> Status {
        let assumptions = assumptions.toZ3_astPointerArray()

        let result = Z3_optimize_check(context.context, optimize,
                                       UInt32(assumptions.count), assumptions)

        return Status.fromZ3_lbool(result)
    }

    /// Retrieve a string that describes the last status returned by `check(_:)`.
    ///
    /// Use this method when `check(_:)` returns `Status.unknown`.
    public func getReasonUnkown() -> String {
        return String(cString: Z3_optimize_get_reason_unknown(context.context, optimize))
    }

    /// Retrieve the model for the last `check`
    ///
    /// The error handler is invoked if a model is not available because the
    /// commands above were not invoked for the given optimization solver, or if
    /// the result was `Status.unsatisfiable`.
    public func getModel() -> Z3Model {
        return Z3Model(context: context, model: Z3_optimize_get_model(context.context, optimize))
    }

    /// Retrieve the unsat core for the last `check`
    /// The unsat core is a subset of the assumptions `a`.
    public func getUnsatCore() -> Z3AstVector {
        return Z3AstVector(context: context, astVector: Z3_optimize_get_unsat_core(context.context, optimize))
    }

    /// Set parameters on optimization context.
    ///
    /// - seealso: `getHelp`
    /// - seealso: `getParamDescrs`
    public func setParams(_ params: Z3Params) {
        Z3_optimize_set_params(context.context, optimize, params.params)
    }

    /// Return the parameter description set for this optimize object.
    public func getParamDescrs() -> Z3ParamDescrs {
        let descrs = Z3_optimize_get_param_descrs(context.context, optimize)

        return Z3ParamDescrs(context: context, descr: descrs!)
    }

    /// Retrieve lower bound value or approximation for the i'th optimization
    /// objective.
    ///
    /// - Parameter idx: index of optimization objective
    /// - seealso: `getUpper`
    /// - seealso: `getUpperAsVector`
    /// - seealso: `getLowerAsVector`
    public func getLower(_ idx: UInt32) -> AnyZ3Ast {
        let ast = Z3_optimize_get_lower(context.context, optimize, idx)

        return AnyZ3Ast(context: context, ast: ast!)
    }

    /// Retrieve upper bound value or approximation for the i'th optimization
    /// objective.
    ///
    /// - Parameter idx: index of optimization objective
    /// - seealso: `getLower`
    /// - seealso: `getUpperAsVector`
    /// - seealso: `getLowerAsVector`
    public func getUpper(_ idx: UInt32) -> AnyZ3Ast {
        let ast = Z3_optimize_get_upper(context.context, optimize, idx)

        return AnyZ3Ast(context: context, ast: ast!)
    }

    /// Retrieve lower bound value or approximation for the i'th optimization
    /// objective.
    /// The returned vector is of length 3. It always contains numerals.
    /// The three numerals are coefficients `a`, `b`, `c` and encode the result of
    /// `getLower()` `a * infinity + b + c * epsilon`.
    ///
    /// - Parameter idx: index of optimization objective
    /// - seealso: `getLower`
    /// - seealso: `getUpper`
    /// - seealso: `getUpperAsVector`
    public func getLowerAsVector(_ idx: UInt32) -> Z3AstVector {
        let astVector = Z3_optimize_get_lower_as_vector(context.context, optimize, idx)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Retrieve upper bound value or approximation for the i'th optimization objective.
    ///
    /// - Parameter idx: index of optimization objective
    /// - seealso: `getLower`
    /// - seealso: `getUpper`
    /// - seealso: `getLowerAsVector`
    public func getUpperAsVector(_ idx: UInt32) -> Z3AstVector {
        let astVector = Z3_optimize_get_upper_as_vector(context.context, optimize, idx)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Print the current context as a string.
    ///
    /// - seealso: `fromFile`
    /// - seealso: `fromString`
    public func toString() -> String {
        return String(cString: Z3_optimize_to_string(context.context, optimize))
    }

    /// Parse an SMT-LIB2 string with assertions, soft constraints and optimization
    /// objectives.
    /// Add the parsed constraints and objectives to the optimization context.
    ///
    /// - seealso: `fromFile`
    /// - seealso: `toString`
    public func fromString(_ str: String) {
        Z3_optimize_from_string(context.context, optimize, str)
    }

    /// Parse an SMT-LIB2 file with assertions, soft constraints and optimization
    /// objectives.
    /// Add the parsed constraints and objectives to the optimization context.
    ///
    /// - seealso: `fromString`
    /// - seealso: `toString`
    public func fromFile(_ str: String) {
        Z3_optimize_from_file(context.context, optimize, str)
    }

    /// Return a string containing a description of parameters accepted by optimize.
    ///
    /// - seealso: `getParamDescrs`
    /// - seealso: `setParams`
    public func getHelp() -> String {
        return String(cString: Z3_optimize_get_help(context.context, optimize))
    }

    /// Retrieve statistics information from the last call to `check(_:)`
    public func getStatistics() -> Z3Stats {
        let stats = Z3_optimize_get_statistics(context.context, optimize)

        return Z3Stats(context: context, stats: stats!)
    }

    /// Return the set of asserted formulas on the optimization context.
    public func getAssertions() -> Z3AstVector {
        let astVector = Z3_optimize_get_assertions(context.context, optimize)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Return objectives on the optimization context.
    ///
    /// If the objective function is a max-sat objective it is returned as a
    /// Pseudo-Boolean (minimization) sum of the form `(+ (if f1 w1 0) (if f2 w2 0) ...)`
    /// If the objective function is entered as a maximization objective, then
    /// return the corresponding minimization objective. In this way the resulting
    /// objective function is always returned as a minimization objective.
    public func getObjectives() -> Z3AstVector {
        let astVector = Z3_optimize_get_objectives(context.context, optimize)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Create a backtracking point.
    ///
    /// The optimize solver contains a set of rules, added facts and assertions.
    /// The set of rules, facts and assertions are restored upon calling `pop()`.
    ///
    /// - seealso: `pop()`
    public func push() {
        Z3_optimize_push(context.context, optimize)
    }

    /// Backtrack one level.
    ///
    /// - precondition: The number of calls to pop cannot exceed calls to push.
    /// - seealso: `push()`
    public func pop() {
        Z3_optimize_pop(context.context, optimize)
    }
}
