import CZ3

public extension Z3Context {
    
    /// Return a tactic associated with the given name.
    ///
    /// The complete list of tactics may be obtained using the procedures
    /// `getNumTactics` and `getTacticName`.
    /// It may also be obtained using the command `(help-tactic)` in the SMT 2.0
    /// front-end.
    ///
    /// Tactics are the basic building block for creating custom solvers for
    /// specific problem domains.
    ///
    /// - throws: If `name` is not a valid/known tactic name.
    func makeTactic(name: String) throws -> Z3Tactic {
        let tactic = Z3_mk_tactic(context, name)
        try rethrowCurrentErrorCodeIfAvailable()
        
        assert(tactic != nil)
        
        return Z3Tactic(context: self, tactic: tactic!)
    }
    
    /// Return the number of builtin tactics available in Z3.
    func getNumTactics() -> UInt32 {
        return Z3_get_num_tactics(context)
    }
    
    /// Return the name of the idx tactic.
    ///
    /// - precondition: `index < getNumTactics()`
    func getTacticName(index: UInt32) -> String {
        precondition(index < getNumTactics(), "index < getNumTactics()")
        
        return String(cString: Z3_get_tactic_name(context, index))
    }
    
    /// Return a string containing a description of the tactic with the given
    /// name.
    func getTacticDescription(name: String) -> String {
        return String(cString: Z3_tactic_get_descr(context, name))
    }
}
