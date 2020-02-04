import CZ3

public class Z3AstVector {
    var context: Z3Context
    var astVector: Z3_ast_vector

    /// Return the size of this AST vector.
    public var size: UInt32 {
        return Z3_ast_vector_size(context.context, astVector)
    }

    /// Return or update the AST at position `index` in this AST vector.
    ///
    /// - precondition: `i < size`
    public subscript(index: UInt32) -> AnyZ3Ast {
        get {
            precondition(index < size)

            let ast = Z3_ast_vector_get(context.context, astVector, index)
            return AnyZ3Ast(context: context, ast: ast!)
        }
        set {
            precondition(index < size)

            Z3_ast_vector_set(context.context, astVector, index, newValue.ast)
        }
    }

    init(context: Z3Context) {
        self.context = context

        astVector = Z3_mk_ast_vector(context)
        Z3_ast_vector_inc_ref(context.context, astVector)
    }

    init(context: Z3Context, astVector: Z3_ast_vector) {
        self.context = context
        self.astVector = astVector

        Z3_ast_vector_inc_ref(context.context, astVector)
    }

    deinit {
        Z3_ast_vector_dec_ref(context.context, astVector)
    }

    public func push(_ ast: AnyZ3Ast) {
        Z3_ast_vector_push(context.context, astVector, ast.ast)
    }
}
