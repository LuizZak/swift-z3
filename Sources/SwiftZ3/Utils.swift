import CZ3

/// Transforms an array of `Z3AstBase` arguments into a C API-compatible pair
/// of `UInt32` count and `UnsafePointer<Z3_ast?>` pointer.
///
/// Note: Pointer value should not outlive lifetime of `closure.
internal func preparingArgsAst<T>(_ arguments: [Z3AstBase], _ closure: (UInt32, UnsafePointer<Z3_ast?>) -> T) -> T {
    let arguments = arguments.toZ3_astPointerArray()
    return closure(UInt32(arguments.count), arguments)
}

/// Transforms an array of `Z3AstBase` arguments into a C API-compatible pair
/// of `UInt32` count and `UnsafeMutablePointer<Z3_ast?>` pointer.
///
/// Note: Pointer value should not outlive lifetime of `closure.`
internal func preparingArgsAstMutable<T>(_ arguments: [Z3AstBase], _ closure: (UInt32, UnsafeMutablePointer<Z3_ast?>) -> T) -> T {
    var arguments = arguments.toZ3_astPointerArray()

    return closure(UInt32(arguments.count), &arguments)
}
