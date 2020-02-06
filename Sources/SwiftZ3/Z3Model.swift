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
    
    /// \brief Evaluate the AST node `t` in the given model.
    /// Returns the result in case of success, or `nil` in case of failure.
    ///
    /// If `completion` is `true`, then Z3 will assign an interpretation for any
    /// constant or function that does not have an interpretation in this model.
    /// These constants and functions were essentially don't cares.
    ///
    /// If `completion` is `false`, then Z3 will not assign interpretations to
    /// constants for functions that do not have interpretations in this model.
    /// Evaluation behaves as the identify function in this case.
    ///
    /// The evaluation may fail for the following reasons:
    ///
    /// - `t` contains a quantifier.
    ///
    /// - the current model is partial, that is, it doesn't have a complete
    /// interpretation for uninterpreted functions.
    /// That is, the option `MODEL_PARTIAL=true` was used.
    ///
    /// - `t` is type incorrect.
    ///
    /// - `Z3Context.interrupt()` was invoked during evaluation.
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
