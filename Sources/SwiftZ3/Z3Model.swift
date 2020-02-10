import CZ3

public class Z3Model {
    /// The context this `Z3Model` belongs
    public let context: Z3Context
    var model: Z3_model
    
    init(context: Z3Context, model: Z3_model) {
        self.context = context
        self.model = model
        Z3_model_inc_ref(context.context, model)
    }
    
    deinit {
        Z3_model_dec_ref(context.context, model)
    }
    
    /// Evaluate the AST node `t` in the given model.
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
    public func eval<T: SortKind>(_ t: Z3Ast<T>, completion: Bool = false) -> Z3Ast<T>? {
        var output: Z3_ast?
        if !Z3_model_eval(context.context, model, t.ast, completion, &output) {
            return nil
        }
        return Z3Ast(context: context, ast: output!)
    }
    
    /// Evaluate the AST node `t` in the given model.
    /// Returns the result in case of success, or `nil` in case of failure.
    ///
    /// Type-erased version.
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
    public func evalAny(_ t: AnyZ3Ast, completion: Bool = false) -> AnyZ3Ast? {
        var output: Z3_ast?
        if !Z3_model_eval(context.context, model, t.ast, completion, &output) {
            return nil
        }
        return AnyZ3Ast(context: context, ast: output!)
    }
    
    /// Return the interpretation (i.e., assignment) of constant `a` in the
    /// current model.
    /// Return `nil`, if the model does not assign an interpretation for `a`.
    /// That should be interpreted as: the value of `a` does not matter.
    ///
    /// - precondition: `a.arity == 0`
    public func getConstInterp(_ a: Z3FuncDecl) -> AnyZ3Ast? {
        if let ast = Z3_model_get_const_interp(context.context, model, a.funcDecl) {
            return AnyZ3Ast(context: context, ast: ast)
        }
        
        return nil
    }
    
    /// Test if there exists an interpretation (i.e., assignment) for `a` in the
    /// current model.
    public func hasInterp(_ a: Z3FuncDecl) -> Bool {
        return Z3_model_has_interp(context.context, model, a.funcDecl)
    }
    
    /// Convert the given model into a string.
    public func toString() -> String {
        return String(cString: Z3_model_to_string(context.context, model))
    }
    
    /// Evaluates expression to a double, assuming it is a numeral already
    ///
    /// Type-erased version.
    ///
    /// Returns 0, in case of failure
    public func doubleAny(_ expr: AnyZ3Ast) -> Double {
        if let ast = evalAny(expr, completion: true) {
            return Z3_get_numeral_double(context.context, ast.ast)
        }
        
        return 0
    }
    
    /// Evaluates expression to a double, assuming it is a numeral already
    ///
    /// Returns 0, in case of failure
    public func double<T: FloatingSort>(_ expr: Z3Ast<T>) -> Double {
        return doubleAny(expr)
    }
    
    /// Evaluates expression to an integer, assuming it is a numeral already
    ///
    /// Type-erased version.
    ///
    /// Returns 0, in case of failure
    public func intAny(_ expr: AnyZ3Ast) -> Int32 {
        if let ast = evalAny(expr, completion: true) {
            var i: Int32 = 0
            if Z3_get_numeral_int(context.context, ast.ast, &i) {
                return i
            }
        }
        
        return 0
    }
    
    /// Evaluates expression to an integer, assuming it is a numeral already
    ///
    /// Returns 0, in case of failure
    public func int(_ expr: Z3Int) -> Int32 {
        return intAny(expr)
    }
}
