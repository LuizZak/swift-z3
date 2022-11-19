import CZ3

/// Parameter set used to configure many components such as: simplifiers,
/// tactics, solvers, etc.
public class Z3Params: Z3RefCountedObject {
    /// The context this `Z3Params` belongs
    public let context: Z3Context
    var params: Z3_params
    
    init(context: Z3Context, params: Z3_params) {
        self.context = context
        self.params = params
    }
    
    override func incRef() {
        Z3_params_inc_ref(context.context, params)
    }

    override func decRef() {
        Z3_params_dec_ref(context.context, params)
    }
    
    /// Add a Boolean parameter `k` with value `v` to the parameter set `p`.
    public func setBool(_ symbol: Z3Symbol, _ value: Bool) {
        Z3_params_set_bool(context.context, params, symbol.symbol, value)
    }
    
    /// Add an unsigned parameter `k` with value `v` to the parameter set `p`.
    public func setUInt(_ symbol: Z3Symbol, _ value: UInt32) {
        Z3_params_set_uint(context.context, params, symbol.symbol, value)
    }
    
    /// Add a double parameter `k` with value `v` to the parameter set `p`.
    public func setDouble(_ symbol: Z3Symbol, _ value: Double) {
        Z3_params_set_double(context.context, params, symbol.symbol, value)
    }
    
    /// Add a symbol parameter `k` with value `v` to the parameter set `p`.
    public func setSymbol(_ symbol: Z3Symbol, _ value: Z3Symbol) {
        Z3_params_set_symbol(context.context, params, symbol.symbol, value.symbol)
    }
    
    /// Convert a parameter set into a string. This function is mainly used for
    /// printing the contents of a parameter set.
    public func toString() -> String {
        return String(cString: Z3_params_to_string(context.context, params))
    }
    
    /// Validate this parameter set against the parameter description set `d`.
    ///
    /// The procedure invokes the error handler if `self` is invalid.
    public func validate(_ d: Z3ParamDescrs) {
        Z3_params_validate(context.context, params, d.descrs)
    }
}
