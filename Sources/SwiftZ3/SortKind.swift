public protocol SortKind {
    static func getSort(_ context: Z3Context) -> Z3Sort
}
public protocol NumericalSort: SortKind { }
public protocol IntOrRealSort: NumericalSort { }
public protocol IntegralSort: IntOrRealSort { }
public protocol BitVectorSort: NumericalSort { }
public protocol FloatingSort: NumericalSort { }

public struct ArraySort<Domain: SortKind, Range: SortKind>: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.makeArraySort(domain: Domain.getSort(context),
                                     range: Range.getSort(context))
    }
}

// MARK: - Bool
extension Bool: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.boolSort()
    }
}

// MARK: - Integers
extension Int32: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
extension UInt32: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
extension Int64: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
extension UInt64: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}

// MARK: - Bit Vectors

/// A bitwidth sort which fits as many bits as the bit width of its `T` parameter
public struct BitVectorOfInt<T: FixedWidthInteger>: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: UInt32(T.bitWidth))
    }
}

/// A bit vector of length 1
public struct BitVectorSort1: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: 1)
    }
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
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: 128)
    }
}

// MARK: - Real
public struct RealSort: NumericalSort, IntOrRealSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.realSort()
    }
}

// MARK: - Floating Points

/// A half precision floating point sort
public struct FP16Sort: NumericalSort {
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
extension Float80: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPointSort(ebits: 15, sbits: 63)
    }
}

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
