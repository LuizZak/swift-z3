import CZ3

public class Z3Pattern: Z3AstBase {
    /// Alias for `ast`
    var pattern: Z3_pattern {
        return ast
    }
    
    init(context: Z3Context, pattern: Z3_pattern) {
        super.init(context: context, ast: pattern)
    }
    
    /// Translate/Copy the AST `self` from its current context to context `target`
    public override func translate(to context: Z3Context) -> Z3Pattern {
        if self.context === context {
            return self
        }

        let newAst = Z3_translate(self.context.context, ast, context.context)

        return Z3Pattern(context: context, pattern: newAst!)
    }
}
