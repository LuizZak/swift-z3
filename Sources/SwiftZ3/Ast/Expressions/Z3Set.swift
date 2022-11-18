/// A Set AST type. Equivalent to an array of domain T and range Bool.
public typealias Z3Set<T: SortKind> = Z3Ast<SetSort<T>>
