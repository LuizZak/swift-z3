// HEADS UP!: Auto-generated file, changes made directly here will be overwritten by code generators.
// Generated by generate_types.py

import CZ3

/// The different kinds of parameters that can be associated with function symbols.
/// \sa Z3_get_decl_num_parameters
/// \sa Z3_get_decl_parameter_kind
public typealias Z3ParameterKind = Z3_parameter_kind

public extension Z3ParameterKind {
    /// is used for integer parameters.
    static let int = Z3_PARAMETER_INT
    
    /// is used for double parameters.
    static let double = Z3_PARAMETER_DOUBLE
    
    /// is used for parameters that are rational numbers.
    static let rational = Z3_PARAMETER_RATIONAL
    
    /// is used for parameters that are symbols.
    static let symbol = Z3_PARAMETER_SYMBOL
    
    /// is used for sort parameters.
    static let sort = Z3_PARAMETER_SORT
    
    /// is used for expression parameters.
    static let ast = Z3_PARAMETER_AST
    
    /// is used for function declaration parameters.
    static let funcDecl = Z3_PARAMETER_FUNC_DECL
}
