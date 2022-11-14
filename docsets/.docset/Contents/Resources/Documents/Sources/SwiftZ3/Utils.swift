import CZ3

internal func preparingArgsAst<T>(_ arguments: [Z3AstBase], _ closure: (UInt32, UnsafePointer<Z3_ast?>) -> T) -> T {
    let arguments = arguments.toZ3_astPointerArray()
    return closure(UInt32(arguments.count), arguments)
}
