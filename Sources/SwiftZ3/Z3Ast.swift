import CZ3

public class Z3Ast<T: SortKind>: AnyZ3Ast {
    /// Translate/Copy the AST `self` from its current context to context `target`
    public override func translate(to context: Z3Context) -> Z3Ast {
        if self.context === context {
            return self
        }

        let newAst = Z3_translate(self.context.context, ast, context.context)

        return Z3Ast(context: context, ast: newAst!)
    }
}

public extension AnyZ3Ast {
    /// An unsafe cast from a generic `AnyZ3Ast` or a specialized `Z3Ast` to
    /// another specialized `Z3Ast` type
    func castTo<T: SortKind>(type: T.Type = T.self) -> Z3Ast<T> {
        return Z3Ast<T>(context: context, ast: ast)
    }
}

/// An Array AST type
public typealias Z3Array<D: SortKind, R: SortKind> = Z3Ast<ArraySort<D, R>>
/// A Set AST type. Equivalent to an array of domain T and range Bool
public typealias Z3Set<T: SortKind> = Z3Ast<SetSort<T>>
/// A Boolean AST type.
public typealias Z3Bool = Z3Ast<Bool>
/// An integer AST type.
/// Notice that this is not the same as a machine integer.
public typealias Z3Int = Z3Ast<IntSort>
/// A 32-bit precision floating-point AST type.
public typealias Z3Float = Z3Ast<Float>
/// A 64-bit precision floating-point AST type.
public typealias Z3Double = Z3Ast<Double>
