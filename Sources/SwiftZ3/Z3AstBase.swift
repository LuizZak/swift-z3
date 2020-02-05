import CZ3

/// Base class for `Z3Sort` and `AnyZ3Ast`
public class Z3AstBase {
    internal var context: Z3Context
    internal var ast: Z3_ast

    /// Return a unique identifier for this AST.
    ///
    /// The identifier is unique up to structural equality. Thus, two ast nodes
    /// created by the same context and having the same children and same
    /// function symbols have the same identifiers. Ast nodes created in the
    /// same context, but having different children or different functions have
    /// different identifiers.
    /// Variables and quantifiers are also assigned different identifiers
    /// according to their structure.
    public var id: UInt32 {
        return Z3_get_ast_id(context.context, ast)
    }

    /// Return a hash code for this AST.
    ///
    /// The hash code is structural. You can use `AnyZ3Ast.id` interchangeably
    /// with this function.
    public var hash: UInt32 {
        return Z3_get_ast_hash(context.context, ast)
    }

    init(context: Z3Context, ast: Z3_ast) {
        self.context = context
        self.ast = ast
    }

    /// Translate/Copy the AST `self` from its current context to context `target`
    public func translate(to context: Z3Context) -> Z3AstBase {
        if self.context === context {
            return self
        }

        let newAst = Z3_translate(self.context.context, ast, context.context)

        return Z3AstBase(context: context, ast: newAst!)
    }
}
