import CZ3

public extension Z3Context {
    // MARK: - Solvers
    
    /// Create a new solver. This solver is a "combined solver" (see combined_solver
    /// module) that internally uses a non-incremental (solver1) and an incremental
    /// solver (solver2). This combined solver changes its behaviour based on how
    /// it is used and how its parameters are set.
    ///
    /// If the solver is used in a non incremental way (i.e. no calls to
    /// `Z3Solver.push()` or `Z3Solver.pop(_:)`, and no calls to `Z3Solver.assert()`
    /// or `Z3Solver.assertAndTrack` after checking satisfiability without an
    /// intervening `Solver.reset()`) then solver1 will be used. This solver will
    /// apply Z3's "default" tactic.
    ///
    /// The "default" tactic will attempt to probe the logic used by the
    /// assertions and will apply a specialized tactic if one is supported.
    /// Otherwise the general `(and-then simplify smt)` tactic will be used.
    ///
    /// If the solver is used in an incremental way then the combined solver
    /// will switch to using solver2 (which behaves similarly to the general
    /// "smt" tactic).
    ///
    /// Note however it is possible to set the `solver2_timeout`,
    /// `solver2_unknown`, and `ignore_solver1` parameters of the combined
    /// solver to change its behaviour.
    ///
    /// The method `Z3Solver.getModel()` retrieves a model if the assertions is
    /// satisfiable (i.e., the result is `Z3LBool.lUndef`) and model construction is
    /// enabled.
    ///
    /// The method `Z3Solver.getModel()` can also be used even if the result is
    /// `Z3LBool.lUndef`, but the returned model is not guaranteed to satisfy
    /// quantified assertions.
    ///
    /// - seealso: `makeSimpleSolver()`
    /// - seealso: `makeSolverForLogic(_:)`
    /// - seealso: `makeSolver(fromTactic:)`
    func makeSolver() -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_solver(context))
    }

    /// Create a new incremental solver.
    ///
    /// This is equivalent to applying the "smt" tactic.
    ///
    /// Unlike `Z3Context.makeSolver()` this solver
    ///     - Does not attempt to apply any logic specific tactics.
    ///     - Does not change its behaviour based on whether it used
    ///     incrementally/non-incrementally.
    ///
    /// Note that these differences can result in very different performance
    /// compared to `Z3Context.makeSolver()`.
    ///
    /// The function `Z3Solver.getModel()` retrieves a model if the
    /// assertions is satisfiable (i.e., the result is `Z3_L_TRUE`) and
    /// model construction is enabled.
    /// The function `Z3Solver.getModel()` can also be used even
    /// if the result is `Z3_L_UNDEF`, but the returned model
    /// is not guaranteed to satisfy quantified assertions.
    ///
    /// - seealso: `makeSolver()`
    /// - seealso: `makeSolverForLogic(_:)`
    /// - seealso: `makeSolver(fromTactic:)`
    func makeSimpleSolver() -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_simple_solver(context))
    }

    /// Create a new solver customized for the given logic.
    /// It behaves like `makeSolver()` if the logic is unknown or unsupported.
    /// 
    /// - seealso: `makeSolver()`
    /// - seealso: `makeSimpleSolver()`
    /// - seealso: `makeSolver(fromTactic:)`
    func makeSolverForLogic(_ symbol: Z3Symbol) -> Z3Solver {
        return Z3Solver(
            context: self,
            solver: Z3_mk_solver_for_logic(context, symbol.symbol)
        )
    }

    /// Create a new solver that is implemented using the given tactic.
    /// The solver supports the commands `Z3Solver.push()` and `Z3Solver.pop()`,
    /// but it will always solve each `Z3Solver.check()` from scratch.
    ///
    /// - seealso: `makeSolver()`
    /// - seealso: `makeSimpleSolver()`
    /// - seealso: `makeSolverForLogic(_:)`
    func makeSolver(fromTactic tactic: Z3Tactic) -> Z3Solver {
        return Z3Solver(
            context: self,
            solver: Z3_mk_solver_from_tactic(context, tactic.tactic)
        )
    }
}
