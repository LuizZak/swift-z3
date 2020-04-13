import CZ3

public typealias Z3AstKind = Z3_ast_kind

public extension Z3AstKind {
    static let numeralAst = Z3_NUMERAL_AST
    static let appAst = Z3_APP_AST
    static let varAst = Z3_VAR_AST
    static let quantifierAst = Z3_QUANTIFIER_AST
    static let sortAst = Z3_SORT_AST
    static let funcDeclAst = Z3_FUNC_DECL_AST
    static let unknownAst = Z3_UNKNOWN_AST
}
