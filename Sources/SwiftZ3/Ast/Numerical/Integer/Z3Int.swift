/// An integer AST type.
/// Note that this is not the same as a machine integer.
public typealias Z3Int = Z3Ast<IntSort>

public extension Z3Int {
    /// Gets the statically-typed Z3Sort associated with `IntSort` from
    /// this `Z3Int`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        T.getSort(context)
    }
}

public extension Z3Int {
    static func % (lhs: Z3Int, rhs: Z3Int) -> Z3Int {
        return lhs.context.makeMod(lhs, rhs)
    }
    
    static func == (lhs: Int32, rhs: Z3Int) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt == rhs
    }
    static func == (lhs: Z3Int, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs == rhsInt
    }

    static func != (lhs: Int32, rhs: Z3Int) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt != rhs
    }
    static func != (lhs: Z3Int, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs != rhsInt
    }

    static func < (lhs: Int32, rhs: Z3Int) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt < rhs
    }
    static func < (lhs: Z3Int, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs < rhsInt
    }

    static func <= (lhs: Int32, rhs: Z3Int) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt <= rhs
    }
    static func <= (lhs: Z3Int, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs <= rhsInt
    }

    static func > (lhs: Int32, rhs: Z3Int) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt > rhs
    }
    static func > (lhs: Z3Int, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs > rhsInt
    }

    static func >= (lhs: Int32, rhs: Z3Int) -> Z3Bool {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt >= rhs
    }
    static func >= (lhs: Z3Int, rhs: Int32) -> Z3Bool {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs >= rhsInt
    }
}

public extension Z3Int {
    // MARK: - Constants Casting
    static func + (lhs: Int32, rhs: Z3Int) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt + rhs
    }
    static func + (lhs: Z3Int, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs + rhsInt
    }
    
    static func - (lhs: Int32, rhs: Z3Int) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt - rhs
    }
    static func - (lhs: Z3Int, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs - rhsInt
    }
    
    static func * (lhs: Int32, rhs: Z3Int) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt * rhs
    }
    static func * (lhs: Z3Int, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs * rhsInt
    }
    
    static func / (lhs: Int32, rhs: Z3Int) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt / rhs
    }
    static func / (lhs: Z3Int, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs / rhsInt
    }
    
    static func % (lhs: Int32, rhs: Z3Int) -> Z3Int {
        let lhsInt = rhs.context.makeInteger(lhs)
        return lhsInt % rhs
    }
    static func % (lhs: Z3Int, rhs: Int32) -> Z3Int {
        let rhsInt = lhs.context.makeInteger(rhs)
        return lhs % rhsInt
    }
}
