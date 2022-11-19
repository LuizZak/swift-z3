import CZ3

/// vector of `Z3AstBase` objects.
public class Z3AstVector {
    /// The context this `Z3AstVector` belongs
    public let context: Z3Context
    var astVector: Z3_ast_vector

    /// Return the size of this AST vector.
    public var size: UInt32 {
        return Z3_ast_vector_size(context.context, astVector)
    }

    /// Return or update the AST at position `index` in this AST vector.
    ///
    /// - precondition: `i < size`
    public subscript(index: UInt32) -> Z3AstBase {
        get {
            precondition(index < size)

            let ast = Z3_ast_vector_get(context.context, astVector, index)
            return Z3AstBase(context: context, ast: ast!)
        }
        set {
            precondition(index < size)

            Z3_ast_vector_set(context.context, astVector, index, newValue.ast)
        }
    }
    
    /// Return or update the AST at position `index` in this AST vector.
    ///
    /// - precondition: `i >= 0 && i < size`
    public subscript(index: Int) -> Z3AstBase {
        get {
            return self[UInt32(index)]
        }
        set {
            self[UInt32(index)] = newValue
        }
    }

    init(context: Z3Context) {
        self.context = context

        astVector = Z3_mk_ast_vector(context.context)
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

    public func push(_ ast: Z3AstBase) {
        Z3_ast_vector_push(context.context, astVector, ast.ast)
    }
    
    /// Translate/Copy the AST vector `self` from its current context to context
    /// `target`
    public func translate(to newContext: Z3Context) -> Z3AstVector {
        if context === newContext {
            return self
        }

        let newAstVector =
            Z3_ast_vector_translate(context.context,
                                    astVector,
                                    newContext.context)
        
        return Z3AstVector(context: newContext, astVector: newAstVector!)
    }
}

extension Z3AstVector: Sequence {
    public func makeIterator() -> AnyIterator<Z3AstBase> {
        var index: UInt32 = 0
        var isAtEnd = false
        
        return AnyIterator {
            if index >= self.size {
                isAtEnd = true
            }
            if isAtEnd {
                return nil
            }
            
            defer { index += 1 }
            
            return self[index]
        }
    }
}
