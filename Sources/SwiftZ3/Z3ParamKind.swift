import CZ3

public typealias Z3ParamKind = Z3_param_kind

public extension Z3ParamKind {
    /// integer parameters.
    static let uint = Z3_PK_UINT
    /// boolean parameters.
    static let bool = Z3_PK_BOOL
    /// double parameters.
    static let double = Z3_PK_DOUBLE
    /// symbol parameters.
    static let symbol = Z3_PK_SYMBOL
    /// string parameters.
    static let string = Z3_PK_STRING
    /// all internal parameter kinds which are not exposed in the API.
    static let other = Z3_PK_OTHER
    /// invalid parameter.
    static let invalid = Z3_PK_INVALID
}
