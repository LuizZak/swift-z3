import CZ3

public class Z3ParamDescrs {
    /// The context this `Z3ParamDescrs` belongs
    public let context: Z3Context
    var descrs: Z3_param_descrs
    
    init(context: Z3Context, descr: Z3_param_descrs) {
        self.context = context
        self.descrs = descr
    }
    
    /// Return the kind associated with the given parameter name `n`.
    public func getKind(_ n: Z3Symbol) -> Z3ParamKind {
        return Z3_param_descrs_get_kind(context.context, descrs, n.symbol)
    }
    
    /// Return the number of parameters in the given parameter description set.
    public func getSize() -> UInt32 {
        return Z3_param_descrs_size(context.context, descrs)
    }
    
    /// Return the name of the parameter at given index `i`.
    ///
    /// - precondition: `i < getSize()`
    public func getName(_ i: UInt32) -> Z3Symbol {
        let symbol = Z3_param_descrs_get_name(context.context, descrs, i)
        return Z3Symbol(context: context, symbol: symbol!)
    }
    
    /// Retrieve documentation string corresponding to parameter name `s`.
    public func getDocumentation(_ s: Z3Symbol) -> String {
        return String(cString: Z3_param_descrs_get_documentation(context.context, descrs, s.symbol))
    }
    
    /// Convert a parameter description set into a string. This function is mainly
    /// used for printing the contents of a parameter description set.
    public func toString(_ s: Z3Symbol) -> String {
        return String(cString: Z3_param_descrs_to_string(context.context, descrs))
    }
}
