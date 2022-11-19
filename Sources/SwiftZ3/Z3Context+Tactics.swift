import CZ3

public extension Z3Context {
    // MARK: - Tactics and Probes
    
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

    /// Return a tactic that just return the given goal.
    func tacticSkip() -> Z3Tactic {
        Z3Tactic(
            context: self,
            tactic: Z3_tactic_skip(context)
        )
    }

    /// Return a tactic that always fails.
    func tacticFail() -> Z3Tactic {
        Z3Tactic(
            context: self,
            tactic: Z3_tactic_fail(context)
        )
    }

    /// Return a tactic that fails if `probe` evaluates to false.
    func tacticFailIf(_ probe: Z3Probe) -> Z3Tactic {
        Z3Tactic(
            context: self,
            tactic: Z3_tactic_fail_if(context, probe.probe)
        )
    }

    /// Return a tactic that fails if the goal is not trivially satisfiable (i.e.,
    /// empty) or trivially unsatisfiable (i.e., contains false).
    func tacticFailIfNotDecided() -> Z3Tactic {
        Z3Tactic(
            context: self,
            tactic: Z3_tactic_fail_if_not_decided(context)
        )
    }

    /// Return a probe associated with the given name.
    /// The complete list of probes may be obtained using the methods
    /// `probeCount` and `probeName(_:)`.
    /// It may also be obtained using the command `(help-tactic)` in the SMT
    /// 2.0 front-end.
    func probe(named name: String) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_mk_probe(context, name)
        )
    }

    /// Return a probe that always evaluates to `value`.
    func probeConst(_ value: Double) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_const(context, value)
        )
    }

    /// Return a probe that evaluates to "true" when the value returned by `p1`
    /// is less than the value returned by `p2`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeLt(_ p1: Z3Probe, _ p2: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_lt(context, p1.probe, p2.probe)
        )
    }

    /// Return a probe that evaluates to "true" when the value returned by `p1`
    /// is greater than the value returned by `p2`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeGt(_ p1: Z3Probe, _ p2: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_gt(context, p1.probe, p2.probe)
        )
    }

    /// Return a probe that evaluates to "true" when the value returned by `p1`
    /// is less than or equal the value returned by `p2`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeLe(_ p1: Z3Probe, _ p2: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_le(context, p1.probe, p2.probe)
        )
    }

    /// Return a probe that evaluates to "true" when the value returned by `p1`
    /// is greater than or equal the value returned by `p2`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeGe(_ p1: Z3Probe, _ p2: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_ge(context, p1.probe, p2.probe)
        )
    }

    /// Return a probe that evaluates to "true" when the value returned by `p1`
    /// is equal to the value returned by `p2`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeEq(_ p1: Z3Probe, _ p2: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_eq(context, p1.probe, p2.probe)
        )
    }

    /// Return a probe that evaluates to "true" when `p1` and `p2` evaluate to
    /// true.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeAnd(_ p1: Z3Probe, _ p2: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_and(context, p1.probe, p2.probe)
        )
    }

    /// Return a probe that evaluates to "true" when `p1` or `p2` evaluate to
    /// true.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeOr(_ p1: Z3Probe, _ p2: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_or(context, p1.probe, p2.probe)
        )
    }

    /// Return a probe that evaluates to "true" when `probe` does not evaluate
    /// to true.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    func probeNot(_ probe: Z3Probe) -> Z3Probe {
        Z3Probe(
            context: self,
            probe: Z3_probe_not(context, probe.probe)
        )
    }
    
    /// Return the name of the tactic of index `index`.
    ///
    /// - precondition: `index < self.tacticCount`
    func tacticName(atIndex index: UInt32) -> String {
        Z3_get_tactic_name(context, index).toString()
    }

    /// Return the name of the probe of index `index`.
    ///
    /// - precondition: `index < self.probeCount`
    func probeName(atIndex index: UInt32) -> String {
        Z3_get_probe_name(context, index).toString()
    }
    
    /// Return a string containing a description of the tactic with the given name.
    func tacticDescription(tacticName: String) -> String {
        Z3_tactic_get_descr(context, tacticName).toString()
    }
    
    /// Return a string containing a description of the probe with the given name.
    func probeDescription(probeName: String) -> String {
        Z3_probe_get_descr(context, probeName).toString()
    }
}
