import CZ3

/// An expression abstract syntax tree (AST) class that is typed with a sort to
/// allow for compile-time static type checking of expressions.
public class Z3Ast<T: SortKind>: AnyZ3Ast {
    override init(context: Z3Context, ast: Z3_ast) {
        super.init(context: context, ast: ast)

        assert(
            T.isAssignableFrom(
                context,
                context.getSort(self)
            ),
            "Attempted to initialize \(Self.self) AST with incompatible Z3 sort \(context.getSort(self))"
        )
    }

    /// Translate/Copy the AST `self` from its current context to context `target`
    public override func translate(to newContext: Z3Context) -> Z3Ast {
        if context === newContext {
            return self
        }

        let newAst = Z3_translate(context.context, ast, newContext.context)

        return Z3Ast(context: newContext, ast: newAst!)
    }
}
