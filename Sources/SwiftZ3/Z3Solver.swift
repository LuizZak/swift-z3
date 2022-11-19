import CZ3

/// Incremental solver, possibly specialized by a particular tactic or logic.
public class Z3Solver {
    /// The context this `Z3Solver` belongs
    public let context: Z3Context
    var solver: Z3_solver
    
    init(context: Z3Context, solver: Z3_solver) {
        self.context = context
        self.solver = solver

        Z3_solver_inc_ref(context.context, solver)
    }

    deinit {
        Z3_solver_dec_ref(context.context, solver)
    }

    /// Return a string describing all solver available parameters.
    ///
    /// - seealso: `getParamDescrs`
    /// - seealso: `setParams`
    public func getHelp() -> String {
        return String(cString: Z3_solver_get_help(context.context, solver))
    }

    /// Set this solver using the given parameters.
    ///
    /// - seealso: `getHelp`
    /// - seealso: `getParamDescrs`
    public func setParams(_ params: Z3Params) {
        Z3_solver_set_params(context.context, solver, params.params)
    }

    /// Return the parameter description set for this solver object.
    public func getParamDescrs() -> Z3ParamDescrs {
        let descrs = Z3_solver_get_param_descrs(context.context, solver)

        return Z3ParamDescrs(context: context, descr: descrs!)
    }

    /// Ad-hoc method for importing model conversion from solver.
    /// 
    /// This method is used for scenarios where `other` has been used to solve a
    /// set of formulas and was interrupted. The `self` solver may be a
    /// strengthening of `other` obtained from cubing (assigning a subset of
    /// literals or adding constraints over the assertions available in `other`).
    /// If `self` ends up being satisfiable, the model for `self` may not
    /// correspond to a model of the original formula due to inprocessing in `other`.
    /// This method is used to take the side-effect of inprocessing into account
    /// when returning a model for `self`.
    public func importModelConverter(from other: Z3Solver) {
        Z3_solver_import_model_converter(context.context, other.solver, solver)
    }

    /// Solver local interrupt.
    ///
    /// Normally you should use `Z3Context.interrupt()` to cancel solvers because
    /// only one solver is enabled concurrently per context.
    /// However, per GitHub issue #1006, there are use cases where it is more
    /// convenient to cancel a specific solver. Solvers that are not selected
    /// for interrupts are left alone.
    public func interrupt() {
        Z3_solver_interrupt(context.context, solver)
    }

    /// Create a backtracking point.
    ///
    /// The solver contains a stack of assertions.
    ///
    /// - seealso: `getNumScopes()`
    /// - seealso: `pop()`
    public func push() {
        Z3_solver_push(context.context, solver)
    }

    /// Backtrack `n` backtracking points.
    ///
    /// - precondition: `n <= getNumScopes()`
    /// - seealso: `getNumScopes()`
    /// - seealso: `push()`
    public func pop(_ n: UInt32) {
        precondition(n <= getNumScopes(), "n <= getNumScopes()")
        Z3_solver_pop(context.context, solver, n)
    }

    /// Remove all assertions from the solver.
    ///
    /// - seealso: `assert()`
    /// - seealso: `assertAndTrack()`
    public func reset() {
        Z3_solver_reset(context.context, solver)
    }

    /// Return the number of backtracking points.
    ///
    /// - seealso: `push()`
    /// - seealso: `pop()`
    public func getNumScopes() -> UInt32 {
        return Z3_solver_get_num_scopes(context.context, solver)
    }
    
    /// Retrieve the model for the last `check()` or `checkAssumptions()`
    ///
    /// The error handler is invoked if a model is not available because the
    /// commands above were not invoked for the given solver, or if the result
    /// was `.unsatisfiable`.
    public func getModel() -> Z3Model? {
        if let ptr = Z3_solver_get_model(context.context, solver) {
            return Z3Model(context: context, model: ptr)
        }
        
        return nil
    }
    
    /// Assert a constraint into the solver.
    ///
    /// The methods `check` and `checkAssumptions` should be used to check whether
    /// the logical context is consistent or not.
    public func assert(_ exp: Z3Bool) {
        Z3_solver_assert(context.context, solver, exp.ast)
    }
    
    /// Assert a list of constraints into the solver.
    ///
    /// The methods `check` and `checkAssumptions` should be used to check whether
    /// the logical context is consistent or not.
    public func assert(_ constraints: [Z3Bool]) {
        for a in constraints {
            assert(a)
        }
    }

    /// Assert a constraint `a` into the solver, and track it (in the unsat) core
    /// using the Boolean constant `p`.
    ///
    /// This API is an alternative to `checkAssumptions` for extracting unsat
    /// cores.
    /// Both APIs can be used in the same solver. The unsat core will contain a
    /// combination of the Boolean variables provided using `assertAndTrack` and
    /// the Boolean literals provided using `checkAssumptions`.
    ///
    /// - precondition: `a` must be a Boolean expression
    /// - precondition: `p` must be a Boolean constant (aka variable).
    /// - seealso: `assert()`
    /// - seealso: `reset()`
    public func assertAndTrack(_ a: Z3Bool, _ p: Z3Bool) {
        Z3_solver_assert_and_track(context.context, solver, a.ast, p.ast)
    }

    /// Load solver assertions from a file.
    ///
    /// - seealso: `fromString()`
    /// - seealso: `toString()`
    public func fromFile(_ fileName: String) throws {
        Z3_solver_from_file(context.context, solver, fileName)
        try context.rethrowCurrentErrorCodeIfAvailable()
    }

    /// Load solver assertions from a string.
    ///
    /// - seealso: `fromFile()`
    /// - seealso: `toString()`
    public func fromString(_ s: String) throws {
        Z3_solver_from_string(context.context, solver, s)
        try context.rethrowCurrentErrorCodeIfAvailable()
    }

    /// Return the set of asserted formulas on the solver.
    public func getAssertions() -> Z3AstVector {
        let astVector = Z3_solver_get_assertions(context.context, solver)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Return the set of units modulo model conversion.
    public func getUnits() -> Z3AstVector {
        let astVector = Z3_solver_get_units(context.context, solver)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Return the trail modulo model conversion, in order of decision level
    /// The decision level can be retrieved using `getLevel()` based on the trail.
    public func getTrail() -> Z3AstVector {
        let astVector = Z3_solver_get_trail(context.context, solver)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Return the set of non units in the solver state.
    public func getNonUnits() -> Z3AstVector {
        let astVector = Z3_solver_get_non_units(context.context, solver)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// retrieve the decision depth of Boolean literals (variables or their
    /// negations).
    /// Assumes a check-sat call and no other calls (to extract models) have
    /// been invoked.
    public func getLevels(_ literals: Z3AstVector, count: UInt32) -> [UInt32] {
        var levels: [UInt32] = (0..<count).map { _ in 0 }

        Z3_solver_get_levels(context.context, solver, literals.astVector,
                             count, &levels)

        return levels
    }

    /// Check whether the assertions in a given solver are consistent or not.
    ///
    /// The method `getModel()` retrieves a model if the assertions is satisfiable
    /// (i.e., the result is `Status.satisfiable`) and model construction is enabled.
    ///
    /// Note that if the call returns `Status.unknown`, Z3 does not ensure that
    /// calls to `getModel()` succeed and any models produced in this case are
    /// not guaranteed to satisfy the assertions.
    ///
    /// The function `getProof()` retrieves a proof if proof generation was enabled
    /// when the context was created, and the assertions are unsatisfiable
    /// (i.e., the result is `Status.unsatisfiable`).
    public func check() -> Status {
        return Status.fromZ3_lbool(Z3_solver_check(context.context, solver))
    }
    
    /// Check whether the assertions in the given solver and optional assumptions
    /// are consistent or not.
    ///
    /// The function `getUnsatCore()` retrieves the subset of the
    /// assumptions used in the unsatisfiability proof produced by Z3.
    public func checkAssumptions(_ assumptions: [AnyZ3Ast]) -> Status {
        return preparingArgsAst(assumptions) { count, assumptions in
            let result = Z3_solver_check_assumptions(context.context, solver, count, assumptions)
            return Status.fromZ3_lbool(result)
        }
    }

    /// Retrieve consequences from solver that determine values of the supplied
    /// function symbols.
    public func getConsequences(assumptions: [Z3Bool],
                                variables: [AnyZ3Ast],
                                consequences: Z3AstVector) -> Status {

        let asms = Z3AstVector(context: context)
        let vars = Z3AstVector(context: context)

        for asm in assumptions {
            asms.push(asm)
        }
        for v in variables {
            vars.push(v)
        }

        let result = Z3_solver_get_consequences(context.context, solver,
                                                asms.astVector, vars.astVector,
                                                consequences.astVector)

        return Status.fromZ3_lbool(result)
    }

    /// Retrieve the proof for the last `check()` or `checkAssumptions()`
    ///
    /// The error handler is invoked if proof generation is not enabled,
    /// or if the commands above were not invoked for the given solver,
    /// or if the result was different from `Status.unsatisfiable`.
    public func getProof() -> AnyZ3Ast? {
        if let ast = Z3_solver_get_proof(context.context, solver) {
            return AnyZ3Ast(context: context, ast: ast)
        }

        return nil
    }

    /// Retrieve the unsat core for the last `checkAssumptions()`
    ///
    /// The unsat core is a subset of the assumptions `a`.
    ///
    /// By default, the unsat core will not be minimized. Generation of a minimized
    /// unsat core can be enabled via the `"sat.core.minimize"` and `"smt.core.minimize"`
    /// settings for SAT and SMT cores respectively. Generation of minimized
    /// unsat cores will be more expensive.
    public func getUnsatCore() -> Z3AstVector {
        let astVector = Z3_solver_get_unsat_core(context.context, solver)

        return Z3AstVector(context: context, astVector: astVector!)
    }

    /// Return a brief justification for an "unknown" result (i.e., `Status.unknown`)
    /// for the commands `check` and `checkAssumptions`
    public func getReasonUnknown() -> String {
        return String(cString: Z3_solver_get_reason_unknown(context.context, solver))
    }

    /// Return statistics for the given solver.
    public func getStatistics() -> Z3Stats {
        return Z3Stats(context: context, stats: Z3_solver_get_statistics(context.context, solver))
    }

    /// Convert a solver into a string.
    ///
    /// - seealso: `fromFile()`
    /// - seealso: `fromString()`
    public func toString() -> String {
        return String(cString: Z3_solver_to_string(context.context, solver))
    }

    /// Convert a solver into a DIMACS formatted string.
    ///
    /// - seealso: `Z3_goal_to_diamcs_string` for requirements.
    public func toDimacsString(includeNames: Bool) -> String {
        return String(cString: Z3_solver_to_dimacs_string(context.context, solver, includeNames))
    }
}
