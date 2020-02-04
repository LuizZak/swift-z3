import CZ3

public class Z3FuncDecl {
    var funcDecl: Z3_func_decl

    init(funcDecl: Z3_func_decl) {
        self.funcDecl = funcDecl
    }
}

internal extension Sequence where Element == Z3_func_decl {
    func toZ3FuncDeclArray() -> [Z3FuncDecl] {
        return map { Z3FuncDecl(funcDecl: $0) }
    }
}

internal extension Sequence where Element == Z3_func_decl? {
    func toZ3FuncDeclArray() -> [Z3FuncDecl] {
        return map { Z3FuncDecl(funcDecl: $0!) }
    }
}
