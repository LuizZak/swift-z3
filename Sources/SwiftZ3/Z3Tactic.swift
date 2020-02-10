import CZ3

public class Z3Tactic {
    /// The context this `Z3Tactic` belongs
    public let context: Z3Context
    var tactic: Z3_tactic
    
    /// Return a string containing a description of parameters accepted by this
    /// tactic.
    public var help: String {
        return String(cString: Z3_tactic_get_help(context.context, tactic))
    }
    
    init(context: Z3Context, tactic: Z3_tactic) {
        self.context = context
        self.tactic = tactic
    }
    
    /// Return the parameter description set for this tactic object.
    public func getParamDescrs() -> Z3ParamDescrs {
        let descrs = Z3_tactic_get_param_descrs(context.context, tactic)

        return Z3ParamDescrs(context: context, descr: descrs!)
    }
}
