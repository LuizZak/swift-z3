import CZ3

/// A class describing a probe in Z3.
/// Probes are used to inspect a goal (aka problem) and collect information that
/// may be used to decide which solver and/or preprocessing step will be used.
public class Z3Probe {
    /// The context this `Z3ParserContext` belongs
    public let context: Z3Context
    let probe: Z3_probe
    
    init(context: Z3Context, probe: Z3_probe) {
        self.context = context
        self.probe = probe
        
        Z3_probe_inc_ref(context.context, probe)
    }
    
    deinit {
        Z3_probe_dec_ref(context.context, probe)
    }

    /// Execute the probe over the goal. The probe always produce a double value.
    /// "Boolean" probes return 0.0 for false, and a value different from 0.0
    /// for true.
    public func apply(over goal: Z3Goal) -> Double {
        Z3_probe_apply(context.context, probe, goal.goal)
    }
}
