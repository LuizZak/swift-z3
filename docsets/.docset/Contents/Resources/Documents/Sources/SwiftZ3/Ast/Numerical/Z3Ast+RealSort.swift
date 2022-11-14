/// A real number AST type.
/// Note that this type is not a floating point number.
public typealias Z3Real = Z3Ast<RealSort>

extension Z3Real {
    // MARK: - Constants Casting

    static func == (lhs: Z3Real, rhs: Int32) -> Z3Bool {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs == rhsReal
    }
    static func == (lhs: Int32, rhs: Z3Real) -> Z3Bool {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal == rhs
    }

    static func != (lhs: Z3Real, rhs: Int32) -> Z3Bool {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs != rhsReal
    }
    static func != (lhs: Int32, rhs: Z3Real) -> Z3Bool {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal != rhs
    }

    static func < (lhs: Z3Real, rhs: Int32) -> Z3Bool {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs < rhsReal
    }
    static func < (lhs: Int32, rhs: Z3Real) -> Z3Bool {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal < rhs
    }

    static func <= (lhs: Z3Real, rhs: Int32) -> Z3Bool {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs <= rhsReal
    }
    static func <= (lhs: Int32, rhs: Z3Real) -> Z3Bool {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal <= rhs
    }

    static func > (lhs: Z3Real, rhs: Int32) -> Z3Bool {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs > rhsReal
    }
    static func > (lhs: Int32, rhs: Z3Real) -> Z3Bool {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal > rhs
    }

    static func >= (lhs: Z3Real, rhs: Int32) -> Z3Bool {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs >= rhsReal
    }
    static func >= (lhs: Int32, rhs: Z3Real) -> Z3Bool {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal >= rhs
    }

    static func + (lhs: Z3Real, rhs: Int32) -> Z3Real {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs + rhsReal
    }
    static func + (lhs: Int32, rhs: Z3Real) -> Z3Real {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal + rhs
    }

    static func - (lhs: Z3Real, rhs: Int32) -> Z3Real {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs - rhsReal
    }
    static func - (lhs: Int32, rhs: Z3Real) -> Z3Real {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal - rhs
    }

    static func * (lhs: Z3Real, rhs: Int32) -> Z3Real {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs * rhsReal
    }
    static func * (lhs: Int32, rhs: Z3Real) -> Z3Real {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal * rhs
    }

    static func / (lhs: Z3Real, rhs: Int32) -> Z3Real {
        let rhsReal = lhs.context.makeReal(rhs)
        return lhs / rhsReal
    }
    static func / (lhs: Int32, rhs: Z3Real) -> Z3Real {
        let lhsReal = rhs.context.makeReal(lhs)
        return lhsReal / rhs
    }
}
