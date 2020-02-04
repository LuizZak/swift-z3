import Z3

public class Z3Context {
    private var cachedFpaRoundingMode: Z3Ast<RoundingMode>?
    internal var context: Z3_context
    
    /// Gets or sets a reference to a rounding mode for floating-point operations
    /// performed on `Z3Ast` instances created by this context.
    ///
    /// Defaults to NearestTiesToEven rounding mode, if not configured.
    public var currentFpaRoundingMode: Z3Ast<RoundingMode> {
        get {
            if let cached = cachedFpaRoundingMode {
                return cached
            }
            let new = makeFpaRoundNearestTiesToEven()
            cachedFpaRoundingMode = new
            return new
        }
        set {
            cachedFpaRoundingMode = newValue
        }
    }

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context(configuration?.config)
    }

    deinit {
        Z3_del_context(context)
    }
    
    /// Interrupt the execution of a Z3 procedure.
    /// This procedure can be used to interrupt: solvers, simplifiers and tactics.
    public func interrupt() {
        Z3_interrupt(context)
    }
    
    /// Create a Z3 (empty) parameter set.
    ///
    /// Starting at Z3 4.0, parameter sets are used to configure many components
    /// such as:
    /// simplifiers, tactics, solvers, etc.
    public func makeParams() -> Z3Params {
        let params = Z3_mk_params(context)!
        return Z3Params(context: self, params: params)
    }
    
    public func makeSolver() -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_solver(context))
    }

    // MARK: -
    
    /// \brief Create a numeral of a given sort.
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
    public func makeNumeral<T: NumericalSort>(number: String, sort: T.Type) -> Z3Ast<T> {
        return Z3Ast(context: self, ast: Z3_mk_numeral(context, number, sort.getSort(self).sort))
    }

    /// Create a real from a fraction.
    ///
    /// - Parameter num: numerator of rational.
    /// - Parameter den: denominator of rational.
    /// - seealso: `Z3_mk_numeral`
    /// - seealso: `Z3_mk_int`
    /// - seealso: `Z3_mk_unsigned_int`
    /// - precondition: `den != 0`
    public func makeReal(_ num: Int32, _ den: Int32) -> Z3Ast<RealSort> {
        return Z3Ast(context: self, ast: Z3_mk_real(context, num, den))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger(value: Int32) -> Z3Ast<Int32> {
        return Z3Ast(context: self, ast: Z3_mk_int(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine unsigned
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger(value: UInt32) -> Z3Ast<UInt32> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger64(value: Int64) -> Z3Ast<Int64> {
        return Z3Ast(context: self, ast: Z3_mk_int64(context, value, intSort().sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `UInt64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger64(value: UInt64) -> Z3Ast<UInt64> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int64(context, value, intSort().sort))
    }
}
