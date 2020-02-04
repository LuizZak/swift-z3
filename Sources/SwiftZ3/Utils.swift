import Z3

internal func preparingArgsAst<T, U>(_ arguments: [Z3Ast<U>], _ closure: (UInt32, UnsafePointer<Z3_ast?>) -> T) -> T {
    let arguments: [Z3_ast?] = arguments.map { $0.ast }
    return closure(UInt32(arguments.count), arguments)
}

internal func preparingArgsAst<T>(_ arguments: [AnyZ3Ast], _ closure: (UInt32, UnsafePointer<Z3_ast?>) -> T) -> T {
    let arguments: [Z3_ast?] = arguments.map { $0.ast }
    return closure(UInt32(arguments.count), arguments)
}
