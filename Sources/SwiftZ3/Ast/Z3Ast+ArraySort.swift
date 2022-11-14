/// An Array AST type
public typealias Z3Array<D: SortKind, R: SortKind> = Z3Ast<ArraySort<D, R>>

public extension Z3Ast {
    /// Array read.
    subscript<D, R>(index: Z3Ast<D>) -> Z3Ast<R> where T == ArraySort<D, R> {
        return context.makeSelect(self, index)
    }
}
