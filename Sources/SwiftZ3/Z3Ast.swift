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

public extension AnyZ3Ast {
    /// An unsafe cast from a generic `AnyZ3Ast` or a specialized `Z3Ast` to
    /// another specialized `Z3Ast` type
    func unsafeCastTo<T: SortKind>(sort: T.Type = T.self) -> Z3Ast<T> {
        return Z3Ast<T>(context: context, ast: ast)
    }
}
