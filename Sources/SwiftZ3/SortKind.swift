public protocol SortKind {
    static func getSort(_ context: Z3Context) -> Z3Sort
}
public protocol NumericalSort: SortKind { }
public protocol IntOrRealSort: NumericalSort { }
public protocol BitVectorSort: NumericalSort {
    /// Bit-width of vector sort
    static var bitWidth: UInt32 { get }
}
public protocol FloatingSort: NumericalSort { }

public struct ArraySort<Domain: SortKind, Range: SortKind>: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.makeArraySort(domain: Domain.getSort(context),
                                     range: Range.getSort(context))
    }
}

public typealias SetSort<T: SortKind> = ArraySort<T, Bool>

// MARK: - Bool
extension Bool: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.boolSort()
    }
}

// MARK: - Integers

/// An integer sort.
/// Note that this is not the same as a machine integer.
public struct IntSort: IntOrRealSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}

// MARK: - Bit Vectors
public extension BitVectorSort {
    static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: bitWidth)
    }
}

/// A bitwidth sort which fits as many bits as the bit width of its `T` parameter
public struct BitVectorOfInt<T: FixedWidthInteger>: BitVectorSort {
    public static var bitWidth: UInt32 { UInt32(T.bitWidth) }
}

/// A bit vector of length 1
public struct BitVectorSort1: BitVectorSort {
    public static let bitWidth: UInt32 = 1
}

/// A bit vector of length 8
public typealias BitVectorSort8 = BitVectorOfInt<Int8>
/// A bit vector of length 16
public typealias BitVectorSort16 = BitVectorOfInt<Int16>
/// A bit vector of length 32
public typealias BitVectorSort32 = BitVectorOfInt<Int32>
/// A bit vector of length 64
public typealias BitVectorSort64 = BitVectorOfInt<Int64>
/// A bit vector of length 128
public struct BitVectorSort128: BitVectorSort {
    public static let bitWidth: UInt32 = 128
}

// MARK: - Real

/// A real number sort.
/// Note that this type is not a floating point number.
public struct RealSort: NumericalSort, IntOrRealSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.realSort()
    }
}

// MARK: - Floating Points

/// A FP sort to type-erase `Z3Ast<T>` instances to.
/// Note: You should not pass this float sort to methods that create new AST
/// based on sort, and doing so will result in a runtime error when trying to
/// call `getSort`
public struct AnyFPSort: FloatingSort {
    /// Note: Fatal-errors
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        fatalError("Type-erased AnyFPSort cannot be used to create Z3Sorts")
    }
}

/// A half precision floating point sort
public struct FP16Sort: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint16Sort()
    }
}
extension Float: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint32Sort()
    }
}
extension Double: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint64Sort()
    }
}

#if os(macOS) || os(Linux)
extension Float80: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPointSort(ebits: 15, sbits: 63)
    }
}
#endif

/// A Quadruple-precision floating point sort
public struct FP128Sort: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint128Sort()
    }
}

/// A RoundingMode sort for values that specify the rounding mode of floating
/// point values
public struct RoundingMode: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.makeFpaRoundingModeSort()
    }
}
