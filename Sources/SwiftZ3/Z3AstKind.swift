import CZ3

public enum Z3AstKind: UInt32 {
    case numeralAst
    case appAst
    case varAst
    case quantifierAst
    case sortAst
    case funcDeclAst
    case unknownAst = 1000
}

internal extension Z3AstKind {
    var toZ3_ast_kind: Z3_ast_kind {
        return Z3_ast_kind(rawValue)
    }

    static func fromZ3_ast_kind(_ value: Z3_ast_kind) -> Z3AstKind {
        return Z3AstKind(rawValue: value.rawValue) ?? .unknownAst
    }
}
