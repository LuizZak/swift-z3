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
/// Note that this is not the same as a machine integer.
public typealias Z3Int = Z3Ast<IntSort>
/// A real number AST type.
/// Note that this type is not a floating point number.
public typealias Z3Real = Z3Ast<RealSort>
/// A 32-bit precision floating-point AST type.
public typealias Z3Float = Z3Ast<Float>
/// A 64-bit precision floating-point AST type.
public typealias Z3Double = Z3Ast<Double>
