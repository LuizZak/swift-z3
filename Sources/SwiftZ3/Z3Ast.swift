import Z3

public class AnyZ3Ast {
    internal var context: Z3Context
    internal var ast: Z3_ast

    init(context: Z3Context, ast: Z3_ast) {
        self.context = context
        self.ast = ast
    }
    
    /// An unsafe cast from a generic `AnyZ3Ast` or a specialized `Z3Ast` to
    /// another specialized `Z3Ast` type
    public func castTo<T: SortKind>() -> Z3Ast<T> {
        return Z3Ast<T>(context: context, ast: ast)
    }
}

public class Z3Ast<T: SortKind>: AnyZ3Ast {
    
}
