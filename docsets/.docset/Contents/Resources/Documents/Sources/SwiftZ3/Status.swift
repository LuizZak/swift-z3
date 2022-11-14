import CZ3

/// Status for invocations of `Z3Solver` and `Z3Optimize` check methods
public enum Status {
    case satisfiable
    case unsatisfiable
    case unknown
}

internal extension Status {
    static func fromZ3_lbool(_ bool: Z3_lbool) -> Status {
        switch bool {
        case Z3_L_TRUE:
            return .satisfiable
        case Z3_L_FALSE:
            return .unsatisfiable
        default:
            return .unknown
        }
    }
}
