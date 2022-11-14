/// A bit width sort which fits as many bits as the bit width of its `T` parameter
public struct BitVectorOfInt<T: FixedWidthInteger>: BitVectorSort {
    public static var bitWidth: UInt32 { UInt32(T.bitWidth) }
}

/// A bit vector of length 8
public typealias BitVectorSort8 = BitVectorOfInt<Int8>

/// A bit vector of length 16
public typealias BitVectorSort16 = BitVectorOfInt<Int16>

/// A bit vector of length 32
public typealias BitVectorSort32 = BitVectorOfInt<Int32>

/// A bit vector of length 64
public typealias BitVectorSort64 = BitVectorOfInt<Int64>
