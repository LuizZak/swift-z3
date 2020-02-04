import Z3

public class Z3Solver {
    var context: Z3Context
    var solver: Z3_solver
    
    init(context: Z3Context, solver: Z3_solver) {
        self.context = context
        self.solver = solver
    }
    
    /// Retrieve the model for the last `check()` or `checkAssumptions()`
    ///
    /// The error handler is invoked if a model is not available because the
    /// commands above were not invoked for the given solver, or if the result
    /// was `Z3_L_FALSE`.
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
    public func assert(_ exp: Z3Ast<Bool>) {
        Z3_solver_assert(context.context, solver, exp.ast)
    }
    
    /// Asserts a series of constraints into the solver.
    ///
    /// The methods `check` and `checkAssumptions` should be used to check whether
    /// the logical context is consistent or not.
    public func assert(_ expressions: [Z3Ast<Bool>]) {
        for exp in expressions {
            assert(exp)
        }
    }
    
    /// Check whether the assertions in a given solver are consistent or not.
    ///
    /// The method `getModel()` retrieves a model if the assertions is satisfiable
    /// (i.e., the result is `Z3_L_TRUE`) and model construction is enabled.
    ///
    /// Note that if the call returns `Z3_L_UNDEF`, Z3 does not ensure that calls
    /// to `getModel()` succeed and any models produced in this case are not
    /// guaranteed to satisfy the assertions.
    ///
    /// The function `getProof()` retrieves a proof if proof generation was enabled
    /// when the context was created, and the assertions are unsatisfiable
    /// (i.e., the result is `Z3_L_FALSE`).
    public func check() -> Z3_lbool {
        return Z3_solver_check(context.context, solver)
    }
    
    /// Check whether the assertions in the given solver and optional assumptions
    /// are consistent or not.
    ///
    /// The function #Z3_solver_get_unsat_core retrieves the subset of the
    /// assumptions used in the unsatisfiability proof produced by Z3.
    public func checkAssumptions(_ assumptions: [AnyZ3Ast]) -> Z3_lbool {
        return preparingArgsAst(assumptions) { count, assumptions in
            Z3_solver_check_assumptions(context.context, solver, count, assumptions)
        }
    }
}
