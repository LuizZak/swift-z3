import CZ3

/// Z3 error codes
public enum Z3ErrorCode: UInt32, Error {
    /// No error.
    case ok
    /// User tried to build an invalid (type incorrect) AST.
    case sortError
    /// Index out of bounds.
    case iob
    /// Invalid argument was provided.
    case invalidArg
    /// An error occurred when parsing a string or file.
    case parserError
    /// Parser output is not available, that is, user didn't invoke
    /// `#Z3_parse_smtlib2_string` or `#Z3_parse_smtlib2_file`.
    case noParser
    /// Invalid pattern was used to build a quantifier.
    case invalidPattern
    /// A memory allocation failure was encountered.
    case memoutFail
    /// A file could not be accessed.
    case fileAccessError
    /// API call is invalid in the current state.
    case invalidUsage
    /// An error internal to Z3 occurred.
    case internalFatal
    /// Trying to decrement the reference counter of an AST that was deleted or
    /// the reference counter was not initialized with `#Z3_inc_ref`.
    case decRefError
    /// Internal Z3 exception. Additional details can be retrieved using
    /// `#Z3_get_error_msg`.
    case exception
    /// Unknown error code.
    case unknown
}

public extension Z3ErrorCode {
    var toZ3_error_code: Z3_error_code {
        return Z3_error_code(rawValue)
    }

    static func fromZ3_error_code(_ errorCode: Z3_error_code) -> Z3ErrorCode {
        return Z3ErrorCode(rawValue: errorCode.rawValue) ?? .unknown
    }
}
