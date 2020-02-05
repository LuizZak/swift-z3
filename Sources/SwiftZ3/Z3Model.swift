import CZ3

public class Z3Model {
    var context: Z3Context
    var model: Z3_model
    
    init(context: Z3Context, model: Z3_model) {
        self.context = context
        self.model = model
        Z3_model_inc_ref(context.context, model)
    }
    
    deinit {
        Z3_model_dec_ref(context.context, model)
    }
    
    public func eval(_ t: AnyZ3Ast, completion: Bool = false) -> AnyZ3Ast? {
        var output: Z3_ast?
        if !Z3_model_eval(context.context, model, t.ast, completion, &output) {
            return nil
        }
        return AnyZ3Ast(context: context, ast: output!)
    }
    
    /// Convert the given model into a string.
    public func toString() -> String {
        return String(cString: Z3_model_to_string(context.context, model))
    }
    
    /// Evaluates expression to a double, assuming it is a numeral already
    ///
    /// Returns 0, in case of failure
    public func double(_ expr: AnyZ3Ast) -> Double {
        if let ast = eval(expr, completion: true) {
            return Z3_get_numeral_double(context.context, ast.ast)
        }
        
        return 0
    }
    
    /// Evaluates expression to an integer, assuming it is a numeral already
    ///
    /// Returns 0, in case of failure
    public func int(_ expr: AnyZ3Ast) -> Int32 {
        if let ast = eval(expr, completion: true) {
            var i: Int32 = 0
            if Z3_get_numeral_int(context.context, ast.ast, &i) {
                return i
            }
        }
        
        return 0
    }
}
