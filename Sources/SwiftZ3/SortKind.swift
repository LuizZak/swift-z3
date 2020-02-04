public protocol SortKind {
    static func getSort(_ context: Z3Context) -> Z3Sort
}
public protocol NumericalSort: SortKind { }
public protocol IntOrRealSort: NumericalSort { }
public protocol IntegralSort: IntOrRealSort { }
public protocol BitVectorSort: NumericalSort { }
public protocol FloatingSort: NumericalSort { }

public struct BoolSort: SortKind {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.boolSort()
    }
}
public struct IntSort: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
public struct UIntSort: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
public struct Int64Sort: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
public struct UInt64Sort: IntegralSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.intSort()
    }
}
public struct BitVectorSort8: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: 8)
    }
}
public struct BitVectorSort16: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: 16)
    }
}
public struct BitVectorSort32: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: 32)
    }
}
public struct BitVectorSort64: BitVectorSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.bitVectorSort(size: 64)
    }
}
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
public struct FP32Sort: FloatingSort {
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context.floatingPoint32Sort()
    }
}
public struct FP64Sort: FloatingSort {
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
