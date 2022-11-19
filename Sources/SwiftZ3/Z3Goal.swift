import CZ3

/// Set of formulas that can be solved and/or transformed using tactics and
/// solvers.
public class Z3Goal: Z3RefCountedObject {
    /// The context this `Z3Goal` belongs
    public let context: Z3Context
    var goal: Z3_goal

    /// Return the depth of this goal. It tracks how many transformations were
    /// applied to it.
    public var depth: UInt32 {
        Z3_goal_depth(context.context, goal)
    }

    /// Returns `true` if this goal contains the formula `false`.
    public var isInconsistent: Bool {
        Z3_goal_inconsistent(context.context, goal)
    }

    /// Return the number of formulas in this goal.
    public var size: UInt32 {
        Z3_goal_size(context.context, goal)
    }

    /// Return a formula from this goal at a given index.
    ///
    /// - precondition: `index < size`
    public subscript(index: UInt32) -> Z3Bool {
        get {
            precondition(index < size)

            return Z3Bool(
                context: context,
                ast: Z3_goal_formula(context.context, goal, index)
            )
        }
    }
    
    /// Return a formula from this goal at a given index.
    ///
    /// - precondition: `index < size`
    public subscript(index: Int) -> Z3Bool {
        get {
            return self[UInt32(index)]
        }
    }

    /// Return the number of formulas, subformulas and terms in the given goal.
    public var expressionCount: UInt32 {
        Z3_goal_num_exprs(context.context, goal)
    }

    /// Return `true` if the goal is empty, and it is precise or the product of
    /// a under approximation.
    public var isDecidedSat: Bool {
        Z3_goal_is_decided_sat(context.context, goal)
    }

    /// Return `true` if the goal contains false, and it is precise or the
    /// product of an over approximation.
    public var isDecidedUnsat: Bool {
        Z3_goal_is_decided_unsat(context.context, goal)
    }
    
    init(context: Z3Context, goal: Z3_goal) {
        self.context = context
        self.goal = goal
    }

    override func incRef() {
        Z3_goal_inc_ref(context.context, goal)
    }

    override func decRef() {
        Z3_goal_dec_ref(context.context, goal)
    }

    /// Add a new formula `ast` to the given goal.
    /// The formula is split according to the following procedure that is applied
    /// until a fixed-point:
    ///     Conjunctions are split into separate formulas.
    ///     Negations are distributed over disjunctions, resulting in separate formulas.
    /// If the goal is `false`, adding new formulas is a no-op.
    /// If the formula `ast` is `true`, then nothing is added.
    /// If the formula `ast` is `false`, then the entire goal is replaced by the
    /// formula `false`.
    public func assert(_ ast: Z3Bool) {
        Z3_goal_assert(context.context, goal, ast.ast)
    }

    /// Erase all formulas from this goal.
    public func reset() {
        Z3_goal_reset(context.context, goal)
    }

    /// Convert a model of the formulas of a goal to a model of an original goal.
    /// The model may be `nil`, in which case the returned model is valid if the
    /// goal was established satisfiable.
    public func convertModel(_ model: Z3Model?) -> Z3Model {
        Z3Model(
            context: context,
            model: Z3_goal_convert_model(
                context.context,
                goal,
                model?.model
            )
        )
    }
    
    /// Convert this goal into a string.
    public func toString() -> String {
        return String(cString: Z3_goal_to_string(context.context, goal))
    }
    
    /// Convert this goal into a DIMACS formatted string.
    ///
    /// The goal must be in CNF. You can convert a goal to CNF by applying the
    /// tseitin-cnf tactic. Bit-vectors are not automatically converted to
    /// Booleans either, so if the caller intends to preserve satisfiability,
    /// it should apply bit-blasting tactics.
    /// Quantifiers and theory atoms will not be encoded.
    public func toDimacsString(includeNames: Bool) -> String {
        return String(cString: Z3_goal_to_dimacs_string(context.context, goal, includeNames))
    }
    
    /// Copy this goal from the context source to the context `newContext` target.
    public func translate(to newContext: Z3Context) -> Z3Goal {
        if context === newContext {
            return self
        }
        
        let newGoal = Z3_goal_translate(context.context, goal, newContext.context)
        
        return Z3Goal(context: newContext, goal: newGoal!)
    }
}
