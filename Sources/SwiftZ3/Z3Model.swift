import Z3

public class Z3Model {
    var context: Z3Context
    var model: Z3_model
    
    init(context: Z3Context, model: Z3_model) {
        self.context = context
        self.model = model
    }
    
    public func eval(_ t: AnyZ3Ast, completion: Bool) -> AnyZ3Ast? {
        var output: Z3_ast?
        if !Z3_model_eval(context.context, model, t.ast, completion, &output) {
            return nil
        }
        return AnyZ3Ast(ast: output!)
    }
    
    /// Evaluates expression to a double, assuming it is a numeral already
    public func double(_ expr: AnyZ3Ast) -> Double {
        if let ast = eval(expr, completion: true) {
            return Z3_get_numeral_double(context.context, ast.ast)
        }
        
        return 0
    }
}
