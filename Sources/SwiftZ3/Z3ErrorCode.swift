import CZ3

public typealias Z3ErrorCode = Z3_error_code

extension Z3ErrorCode: Error { }

public extension Z3ErrorCode {
    /// No error.
    static let ok = Z3_OK
    /// User tried to build an invalid (type incorrect) AST.
    static let sortError = Z3_SORT_ERROR
    /// Index out of bounds.
    static let iob = Z3_IOB
    /// Invalid argument was provided.
    static let invalidArg = Z3_INVALID_ARG
    /// An error occurred when parsing a string or file.
    static let parserError = Z3_PARSER_ERROR
    /// Parser output is not available, that is, user didn't invoke
    /// `Z3_parse_smtlib2_string` or `Z3_parse_smtlib2_file`.
    static let noParser = Z3_NO_PARSER
    /// Invalid pattern was used to build a quantifier.
    static let invalidPattern = Z3_INVALID_PATTERN
    /// A memory allocation failure was encountered.
    static let memoutFail = Z3_MEMOUT_FAIL
    /// A file could not be accessed.
    static let fileAccessError = Z3_FILE_ACCESS_ERROR
    /// API call is invalid in the current state.
    static let internalFatal = Z3_INTERNAL_FATAL
    /// An error internal to Z3 occurred.
    static let invalidUsage = Z3_INVALID_USAGE
    /// Trying to decrement the reference counter of an AST that was deleted or
    /// the reference counter was not initialized with `Z3_inc_ref`.
    static let decRefError = Z3_DEC_REF_ERROR
    /// Internal Z3 exception. Additional details can be retrieved using
    /// `Z3_get_error_msg`.
    static let exception = Z3_EXCEPTION
}
