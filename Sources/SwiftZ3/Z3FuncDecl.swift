import CZ3

public class Z3FuncDecl {
    var context: Z3Context
    var funcDecl: Z3_func_decl

    init(context: Z3Context, funcDecl: Z3_func_decl) {
        self.context = context
        self.funcDecl = funcDecl
    }
}

internal extension Sequence where Element == Z3_func_decl {
    func toZ3FuncDeclArray(context: Z3Context) -> [Z3FuncDecl] {
        return map { Z3FuncDecl(context: context, funcDecl: $0) }
    }
}

internal extension Sequence where Element == Z3_func_decl? {
    func toZ3FuncDeclArray(context: Z3Context) -> [Z3FuncDecl] {
        return map { Z3FuncDecl(context: context, funcDecl: $0!) }
    }
}
