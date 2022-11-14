
public extension Z3Ast where T == IntSort {
    static func % (lhs: Z3Ast, rhs: Z3Ast) -> Z3Ast {
        return lhs.context.makeMod(lhs, rhs)
    }
    
    static func == (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs != rhsInt
    }

    static func < (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt < rhs
    }
    static func < (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs < rhsInt
    }

    static func <= (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt <= rhs
    }
    static func <= (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs <= rhsInt
    }

    static func > (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt > rhs
    }
    static func > (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs > rhsInt
    }

    static func >= (lhs: Int32, rhs: Z3Ast) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt >= rhs
    }
    static func >= (lhs: Z3Ast, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs >= rhsInt
    }
}

public extension Z3Ast where T == IntSort {
    // MARK: - Constants Casting
    static func + (lhs: Int32, rhs: Z3Ast) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt + rhs
    }
    static func + (lhs: Z3Ast, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs + rhsInt
    }
    
    static func - (lhs: Int32, rhs: Z3Ast) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt - rhs
    }
    static func - (lhs: Z3Ast, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs - rhsInt
    }
    
    static func * (lhs: Int32, rhs: Z3Ast) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt * rhs
    }
    static func * (lhs: Z3Ast, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs * rhsInt
    }
    
    static func / (lhs: Int32, rhs: Z3Ast) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt / rhs
    }
    static func / (lhs: Z3Ast, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs / rhsInt
    }
    
    static func % (lhs: Int32, rhs: Z3Ast) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt % rhs
    }
    static func % (lhs: Z3Ast, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs % rhsInt
    }
}
