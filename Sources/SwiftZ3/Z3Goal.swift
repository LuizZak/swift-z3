import CZ3

public class Z3Goal {
    /// The context this `Z3Goal` belongs
    public let context: Z3Context
    var goal: Z3_goal
    
    init(context: Z3Context, goal: Z3_goal) {
        self.context = context
        self.goal = goal
        
        Z3_goal_inc_ref(context.context, goal)
    }
    
    deinit {
        Z3_goal_dec_ref(context.context, goal)
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
    public func toDimacsString() -> String {
        return String(cString: Z3_goal_to_dimacs_string(context.context, goal))
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
