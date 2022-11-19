import CZ3

/// A class describing a probe in Z3.
/// Probes are used to inspect a goal (aka problem) and collect information that
/// may be used to decide which solver and/or preprocessing step will be used.
public class Z3Probe: Z3RefCountedObject {
    /// The context this `Z3ParserContext` belongs
    public let context: Z3Context
    let probe: Z3_probe
    
    init(context: Z3Context, probe: Z3_probe) {
        self.context = context
        self.probe = probe
    }

    override func incRef() {
        Z3_probe_inc_ref(context.context, probe)
    }

    override func decRef() {
        Z3_probe_dec_ref(context.context, probe)
    }

    /// Execute the probe over the goal. The probe always produce a double value.
    /// "Boolean" probes return 0.0 for false, and a value different from 0.0
    /// for true.
    public func apply(over goal: Z3Goal) -> Double {
        Z3_probe_apply(context.context, probe, goal.goal)
    }

    /// Return a tactic that fails if this probe evaluates to false.
    public func tacticForFailure() -> Z3Tactic {
        context.tacticFailIf(self)
    }
}

public extension Z3Probe {
    /// Return a probe that evaluates to "true" when the value returned by `lhs`
    /// is less than the value returned by `rhs`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    /// - precondition: `lhs` and `rhs` share the same context.
    static func < (lhs: Z3Probe, rhs: Z3Probe) -> Z3Probe {
        lhs.context.probeLt(lhs, rhs)
    }

    /// Return a probe that evaluates to "true" when the value returned by `lhs`
    /// is less than or equal to the value returned by `rhs`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    /// - precondition: `lhs` and `rhs` share the same context.
    static func <= (lhs: Z3Probe, rhs: Z3Probe) -> Z3Probe {
        lhs.context.probeLe(lhs, rhs)
    }

    /// Return a probe that evaluates to "true" when the value returned by `lhs`
    /// is greater than the value returned by `rhs`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    /// - precondition: `lhs` and `rhs` share the same context.
    static func > (lhs: Z3Probe, rhs: Z3Probe) -> Z3Probe {
        lhs.context.probeGt(lhs, rhs)
    }

    /// Return a probe that evaluates to "true" when the value returned by `lhs`
    /// is greater than or equal to the value returned by `rhs`.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    /// - precondition: `lhs` and `rhs` share the same context.
    static func >= (lhs: Z3Probe, rhs: Z3Probe) -> Z3Probe {
        lhs.context.probeGe(lhs, rhs)
    }

    /// Return a probe that evaluates to "true" when `lhs` and `rhs` evaluate to
    /// true.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    /// - precondition: `lhs` and `rhs` share the same context.
    static func == (lhs: Z3Probe, rhs: Z3Probe) -> Z3Probe {
        lhs.context.probeAnd(lhs, rhs)
    }

    /// Return a probe that evaluates to "true" when `lhs` or `rhs` evaluate to
    /// true.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    /// - precondition: `lhs` and `rhs` share the same context.
    static func || (lhs: Z3Probe, rhs: Z3Probe) -> Z3Probe {
        lhs.context.probeOr(lhs, rhs)
    }

    /// Return a probe that evaluates to "true" when `probe` does not evaluate
    /// to true.
    ///
    /// - remark: For probes, "true" is any value different from 0.0.
    static prefix func ! (probe: Z3Probe) -> Z3Probe {
        probe.context.probeNot(probe)
    }
}
