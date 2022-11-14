import CZ3

public class Z3Ast<T: SortKind>: AnyZ3Ast {
    /// Translate/Copy the AST `self` from its current context to context `target`
    public override func translate(to newContext: Z3Context) -> Z3Ast {
        if context === newContext {
            return self
        }

        let newAst = Z3_translate(context.context, ast, newContext.context)

        return Z3Ast(context: newContext, ast: newAst!)
    }
}
