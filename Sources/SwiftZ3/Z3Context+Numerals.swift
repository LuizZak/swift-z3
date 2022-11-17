import CZ3

public extension Z3Context {
    // MARK: - Numeral creation and extraction
    
    /// Create a numeral of a given sort.
    ///
    /// - seealso: `makeInteger()`
    /// - seealso: `makeUnsignedInteger()`
    /// - Parameter number: A string representing the numeral value in decimal
    /// notation. The string may be of the form `[num]*[.[num]*][E[+|-][num]+]`.
    /// If the given sort is a real, then the numeral can be a rational, that is,
    /// a string of the form `[num]* / [num]*` .
    /// - Parameter sort: The sort of the numeral. In the current implementation,
    /// the given sort can be an int, real, finite-domain, or bit-vectors of
    /// arbitrary size.
    func makeNumeral<T: NumericalSort>(number: String, sort: T.Type) -> Z3Ast<T> {
        return makeNumeral(
            number: number,
            sort: sort.getSort(self)
        ).unsafeCastTo()
    }
    
    /// Create a numeral of a given sort.
    ///
    /// - seealso: `makeInteger()`
    /// - seealso: `makeUnsignedInteger()`
    /// - Parameter number: A string representing the numeral value in decimal
    /// notation. The string may be of the form `[num]*[.[num]*][E[+|-][num]+]`.
    /// If the given sort is a real, then the numeral can be a rational, that is,
    /// a string of the form `[num]* / [num]*` .
    /// - Parameter sort: The sort of the numeral. In the current implementation,
    /// the given sort can be an int, real, finite-domain, or bit-vectors of
    /// arbitrary size.
    func makeNumeral(number: String, sort: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(
            context: self,
            ast: Z3_mk_numeral(context, number, sort.sort)
        )
    }

    /// Create a real from a fraction.
    ///
    /// - Parameter num: numerator of rational.
    /// - Parameter den: denominator of rational.
    /// - seealso: `makeNumeral`
    /// - seealso: `makeInteger`
    /// - seealso: `makeUnsignedInteger`
    /// - precondition: `den != 0`
    func makeReal(_ num: Int32, _ den: Int32 = 1) -> Z3Real {
        return Z3Real(context: self, ast: Z3_mk_real(context, num, den))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeInteger(_ value: Int32) -> Z3Int {
        return Z3Int(
            context: self,
            ast: Z3_mk_int(context, value, Z3Int.getSort(self).sort)
        )
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeIntegerBv(_ value: Int32) -> Z3BitVector32 {
        return Z3BitVector32(
            context: self,
            ast: Z3_mk_int(context, value, Z3BitVector32.getSort(self).sort)
        )
    }

    /// Create a numeral of a bit-vector of one bit.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeInteger1Bv(_ value: UInt32) -> Z3BitVector1 {
        return Z3BitVector1(
            context: self,
            ast: Z3_mk_unsigned_int(context, value, Z3BitVector1.getSort(self).sort)
        )
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine unsigned
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeUnsignedInteger(_ value: UInt32) -> Z3Int {
        return Z3Int(
            context: self,
            ast: Z3_mk_unsigned_int(context, value, Z3Int.getSort(self).sort)
        )
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeUnsignedIntegerBv(_ value: UInt32) -> Z3BitVectorU32 {
        return Z3BitVectorU32(
            context: self,
            ast: Z3_mk_unsigned_int(context, value, Z3BitVectorU32.getSort(self).sort)
        )
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeInteger64(_ value: Int64) -> Z3Int {
        return Z3Int(
            context: self,
            ast: Z3_mk_int64(context, value, Z3Int.getSort(self).sort)
        )
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeInteger64Bv(_ value: Int64) -> Z3BitVector64 {
        return Z3BitVector64(
            context: self,
            ast: Z3_mk_int64(context, value, Z3BitVector64.getSort(self).sort)
        )
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `UInt64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeUnsignedInteger64(_ value: UInt64) -> Z3Int {
        return Z3Int(
            context: self,
            ast: Z3_mk_unsigned_int64(context, value, Z3Int.getSort(self).sort)
        )
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `UInt64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    /// - seealso: `makeUnsignedInteger64(_:)`
    func makeUnsignedInteger64Any(_ value: UInt64, sort: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(
            context: self,
            ast: Z3_mk_unsigned_int64(context, value, sort.sort)
        )
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeUnsignedInteger64Bv(_ value: UInt64) -> Z3BitVectorU64 {
        return Z3BitVectorU64(
            context: self,
            ast: Z3_mk_unsigned_int64(context, value, Z3BitVectorU64.getSort(self).sort)
        )
    }
    
    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a 128-bit integer.
    /// The initial value is split into two `UInt64` bit patterns that fit the low
    /// (0-63) and high (64-127) bit ranges.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeInteger128Bv(highBits: UInt64, lowBits: UInt64) -> Z3BitVector128 {
        return Z3BitVector128(
            context: self,
            ast: Z3_mk_numeral(context, "\(highBits)\(lowBits)", Z3BitVector128.getSort(self).sort)
        )
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a 128-bit integer.
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeUnsignedInteger128Bv(highBits: UInt64, lowBits: UInt64) -> Z3BitVector128 {
        return Z3BitVector128(
            context: self,
            ast: Z3_mk_numeral(context, "\(highBits)\(lowBits)", Z3BitVector128.getSort(self).sort)
        )
    }

    /// Create a bit-vector numeral from a vector of Booleans.
    ///
    /// - precondition: `!values.isEmpty`
    ///
    /// - seealso: `makeNumeral(number:sort:)`
    func makeIntegerBvFromBools(_ values: [Bool]) -> AnyZ3BitVector {
        precondition(!values.isEmpty)

        return AnyZ3BitVector(
            context: self,
            ast: Z3_mk_bv_numeral(context, UInt32(values.count), values)
        )
    }

    /// Return numeral value, as a decimal string of a numeric constant term
    func getNumeralString(_ numeral: AnyZ3Ast) -> String {
        Z3_get_numeral_string(context, numeral.ast).toString()
    }

    /// Similar to `getNumeralString(_:)`, but only succeeds if the value can
    /// fit in a machine `Int64` int. Returns `nil` if it fails.
    func getNumeralInt64(_ numeral: AnyZ3Ast) -> Int64? {
        var result: Int64 = 0
        if !Z3_get_numeral_int64(context, numeral.ast, &result) {
            return nil
        }

        return result
    }

    /// Similar to `getNumeralString(_:)`, but only succeeds if the value can
    /// fit in a machine `UInt64` int. Returns `nil` if it fails.
    func getNumeralUInt64(_ numeral: AnyZ3Ast) -> UInt64? {
        var result: UInt64 = 0
        if !Z3_get_numeral_uint64(context, numeral.ast, &result) {
            return nil
        }

        return result
    }
}
