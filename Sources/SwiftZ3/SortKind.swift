public protocol SortKind {
    static func getSort(_ context: Z3Context) -> Z3Sort
}
public protocol NumericalSort: SortKind { }
public protocol IntOrRealSort: NumericalSort { }
public protocol IntegralSort: IntOrRealSort { }
public protocol BitVectorSort: NumericalSort { }
public protocol FloatingSort: NumericalSort { }

extension Bool: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.boolSort()
    }
}
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
/// A bitwidth sort which fits as many bits as the bit width of its `T` parameter
public struct BitVectorOfInt<T: FixedWidthInteger>: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: UInt32(T.bitWidth))
    }
}
public typealias BitVectorSort8 = BitVectorOfInt<Int8>
public typealias BitVectorSort16 = BitVectorOfInt<Int16>
public typealias BitVectorSort32 = BitVectorOfInt<Int32>
public typealias BitVectorSort64 = BitVectorOfInt<Int64>

public struct BitVectorSort128: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: 128)
    }
}
public struct RealSort: NumericalSort, IntOrRealSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.realSort()
    }
}
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
public struct FP128Sort: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint128Sort()
    }
}
public struct RoundingMode: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.makeFpaRoundingModeSort()
    }
}
