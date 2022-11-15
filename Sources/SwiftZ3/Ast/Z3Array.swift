/// An Array AST type
public typealias Z3Array<D: SortKind, R: SortKind> = Z3Ast<ArraySort<D, R>>

public extension Z3Array {
    /// Gets the statically-typed array Z3Sort associated with `ArraySort<D, R>`
    /// from this `Z3Array`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        T.getSort(context)
    }
}

public extension Z3Array {
    /// Array read.
    subscript<D, R>(index: Z3Ast<D>) -> Z3Ast<R> where T == ArraySort<D, R> {
        return context.makeSelect(self, index)
    }
}
