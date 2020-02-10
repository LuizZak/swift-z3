import CZ3

/// Base class for `Z3Sort` and `AnyZ3Ast`
public class Z3AstBase {
    /// The context this `Z3AstBase` belongs
    public let context: Z3Context
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

    /// Return `true` if this AST is an application
    public var isApp: Bool {
        return Z3_is_app(context.context, ast)
    }

    public var isNumeralAst: Bool {
        return Z3_is_numeral_ast(context.context, ast)
    }

    /// Return `true` if this AST is a real algebraic number.
    public var isAlgebraicNumber: Bool {
        return Z3_is_algebraic_number(context.context, ast)
    }

    /// Return `true` if this AST is a BoundVariable
    public var isVar: Bool {
        return astKind == .varAst
    }

    /// Return `true` if this AST is a Quantifier
    public var isQuantifier: Bool {
        return astKind == .quantifierAst
    }

    /// Return `true` if this AST is a Sort
    public var isSort: Bool {
        return astKind == .sortAst
    }

    /// Return `true` if this AST is a FunctionDeclaration
    public var isFuncDecl: Bool {
        return astKind == .funcDeclAst
    }

    /// Determine if an ast is a universal quantifier.
    public var isQuantifierForAll: Bool {
        return Z3_is_quantifier_forall(context.context, ast)
    }

    /// Determine if ast is an existential quantifier.
    public var isQuantifierExists: Bool {
        return Z3_is_quantifier_exists(context.context, ast)
    }

    /// Determine if ast is a lambda expression.
    ///
    /// - precondition: `astKind == Z3AstKind.quantifierAst`
    public var isLambda: Bool {
        return Z3_is_lambda(context.context, ast)
    }

    /// Return the kind of the given AST.
    public var astKind: Z3AstKind {
        return Z3AstKind.fromZ3_ast_kind(Z3_get_ast_kind(context.context, ast))
    }

    init(context: Z3Context, ast: Z3_ast) {
        self.context = context
        self.ast = ast
    }

    /// Translate/Copy the AST `self` from its current context to context `target`
    public func translate(to newContext: Z3Context) -> Z3AstBase {
        if context === newContext {
            return self
        }

        let newAst = Z3_translate(context.context, ast, newContext.context)

        return Z3AstBase(context: newContext, ast: newAst!)
    }
    
    /// Convert the current AST node into a string.
    public func toString() -> String {
        return String(cString: Z3_ast_to_string(context.context, ast))
    }
}
