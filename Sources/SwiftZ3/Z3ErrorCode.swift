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

internal extension Z3ErrorCode {
    var toZ3_error_code: Z3_error_code {
        return Z3_error_code(rawValue)
    }

    static func fromZ3_error_code(_ errorCode: Z3_error_code) -> Z3ErrorCode {
        switch errorCode {
        case Z3_OK:
            return .ok
        case Z3_SORT_ERROR:
            return .sortError
        case Z3_IOB:
            return .iob
        case Z3_INVALID_ARG:
            return .invalidArg
        case Z3_PARSER_ERROR:
            return .parserError
        case Z3_NO_PARSER:
            return .noParser
        case Z3_INVALID_PATTERN:
            return .invalidPattern
        case Z3_MEMOUT_FAIL:
            return .memoutFail
        case Z3_FILE_ACCESS_ERROR:
            return .fileAccessError
        case Z3_INTERNAL_FATAL:
            return .internalFatal
        case Z3_INVALID_USAGE:
            return .invalidUsage
        case Z3_DEC_REF_ERROR:
            return .decRefError
        case Z3_EXCEPTION:
            return .exception
        default:
            return .unknown
        }
    }
}
