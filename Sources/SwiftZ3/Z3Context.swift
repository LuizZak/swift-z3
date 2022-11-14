import CZ3

public class Z3Context {
    /// Indicates whether the current Z3_context associated with this Z3Context
    /// was borrowed from another live Z3Context instance. Used to avoid calling
    /// deinitializers on the borrowed pointer.
    private var isBorrowed: Bool = false
    private var cachedFpaRoundingMode: Z3Ast<RoundingModeSort>?
    internal var context: Z3_context
    
    /// Gets or sets a reference to a rounding mode for floating-point operations
    /// performed on `Z3FloatingPoint` instances created by this context.
    ///
    /// Changes to this value change the rounding mode that is passed to the
    /// underlying `Z3_mk_fpa_*` methods that are generated via overloaded operators
    /// on `Z3FloatingPoint` instances.
    ///
    /// Defaults to NearestTiesToEven rounding mode, if not configured.
    public var currentFpaRoundingMode: Z3Ast<RoundingModeSort> {
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

    /// Return the error code for the last API call.
    public var errorCode: Z3ErrorCode {
        return Z3_get_error_code(context)
    }
    
    /// Return `true` if the last API call resulted in an error.
    public var hasError: Bool {
        return errorCode != .ok
    }

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context(configuration?.config)
        Z3_set_error_handler(context) { (context, code) in
            print("Z3 Error: \(Z3_get_error_msg(context, code).toString())")
        }
    }
    
    internal init(borrowing context: Z3_context) {
        self.context = context
        isBorrowed = true
    }

    deinit {
        if !isBorrowed {
            Z3_del_context(context)
        }
    }

    /// Return a string describing the given error code.
    public func errorMessage(_ code: Z3ErrorCode) -> String {
        return Z3_get_error_msg(context, code).toString()
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

    /// Create a new solver. This solver is a "combined solver" (see combined_solver
    /// module) that internally uses a non-incremental (solver1) and an incremental
    /// solver (solver2). This combined solver changes its behaviour based on how
    /// it is used and how its parameters are set.
    ///
    /// If the solver is used in a non incremental way (i.e. no calls to
    /// `Z3Solver.push()` or `Z3Solver.pop()`, and no calls to `Z3Solver.assert()` or
    /// `Z3Solver.assertAndTrack` after checking satisfiability without an
    /// intervening `Solver.reset()`) then solver1 will be used. This solver will
    /// apply Z3's "default" tactic.
    ///
    /// The "default" tactic will attempt to probe the logic used by the
    /// assertions and will apply a specialized tactic if one is supported.
    /// Otherwise the general `(and-then simplify smt)` tactic will be used.
    ///
    /// If the solver is used in an incremental way then the combined solver
    /// will switch to using solver2 (which behaves similarly to the general
    /// "smt" tactic).
    ///
    /// Note however it is possible to set the `solver2_timeout`,
    /// `solver2_unknown`, and `ignore_solver1` parameters of the combined
    /// solver to change its behaviour.
    ///
    /// The method `Z3Solver.getModel()` retrieves a model if the assertions is
    /// satisfiable (i.e., the result is `Z3_L_TRUE`) and model construction is
    /// enabled.
    ///
    /// The method `Z3Solver.getModel()` can also be used even if the result is
    /// `Z3_L_UNDEF`, but the returned model is not guaranteed to satisfy
    /// quantified assertions.
    public func makeSolver() -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_solver(context))
    }

    /// \brief Create a new solver that is implemented using the given tactic.
    /// The solver supports the commands `Z3Solver.push()` and `Z3Solver.pop()`,
    /// but it will always solve each `Z3Solver.check()` from scratch.
    public func makeSolver(forTactic tactic: Z3Tactic) -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_solver_from_tactic(context, tactic.tactic))
    }

    /// Create a new incremental solver.
    ///
    /// This is equivalent to applying the "smt" tactic.
    ///
    /// Unlike `Z3Context.makeSolver()` this solver
    ///     - Does not attempt to apply any logic specific tactics.
    ///     - Does not change its behaviour based on whether it used
    ///     incrementally/non-incrementally.
    ///
    /// Note that these differences can result in very different performance
    /// compared to `Z3Context.makeSolver()`.
    ///
    /// The function `Z3Solver.getModel()` retrieves a model if the
    /// assertions is satisfiable (i.e., the result is `Z3_L_TRUE`) and
    /// model construction is enabled.
    /// The function `Z3Solver.getModel()` can also be used even
    /// if the result is `Z3_L_UNDEF`, but the returned model
    /// is not guaranteed to satisfy quantified assertions.
    public func makeSimpleSolver() -> Z3Solver {
        return Z3Solver(context: self, solver: Z3_mk_simple_solver(context))
    }

    /// Create a new optimize context.
    public func makeOptimize() -> Z3Optimize {
        return Z3Optimize(context: self, optimize: Z3_mk_optimize(context))
    }
    
    /// Return a string describing all available parameters.
    ///
    /// - seealso: `simplifyEx`
    /// - seealso: `getSimplifyParamDescrs`
    public func getSimplifyHelp() -> String {
        return String(cString: Z3_simplify_get_help(context))
    }
    
    /// Return the parameter description set for the simplify procedure.
    ///
    /// - seealso: `simplifyEx`
    /// - seealso: `getSimplifyHelp`
    public func getSimplifyParamDescrs() -> Z3ParamDescrs {
        let paramDescrs = Z3_simplify_get_param_descrs(context)
        
        return Z3ParamDescrs(context: self, descr: paramDescrs!)
    }
    
    /// Interface to simplifier.
    ///
    /// Provides an interface to the AST simplifier used by Z3.
    /// It returns an AST object which is equal to the argument.
    /// The returned AST is simplified using algebraic simplification rules,
    /// such as constant propagation (propagating true/false over logical connectives).
    ///
    /// - seealso: `simplifyEx`
    public func simplify(_ a: AnyZ3Ast) -> AnyZ3Ast {
        let ast = Z3_simplify(context, a.ast)
        
        return AnyZ3Ast(context: self, ast: ast!)
    }
    
    /// Interface to simplifier.
    ///
    /// Provides an interface to the AST simplifier used by Z3.
    /// This procedure is similar to #Z3_simplify, but the behavior of the
    /// simplifier can be configured using the given parameter set.
    ///
    /// - seealso: `simplify`
    /// - seealso: `getSimplifyHelp`
    /// - seealso: `getSimplifyParamDescrs`
    public func simplifyEx(_ a: AnyZ3Ast, _ p: Z3Params) -> AnyZ3Ast {
        let ast = Z3_simplify_ex(context, a.ast, p.params)
        
        return AnyZ3Ast(context: self, ast: ast!)
    }

    // MARK: -
    
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
    public func makeNumeral<T: NumericalSort>(number: String, sort: T.Type) -> Z3Ast<T> {
        return makeNumeral(number: number, sort: sort.getSort(self)).unsafeCastTo()
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
    public func makeNumeral(number: String, sort: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_numeral(context, number, sort.sort))
    }

    /// Create a real from a fraction.
    ///
    /// - Parameter num: numerator of rational.
    /// - Parameter den: denominator of rational.
    /// - seealso: `makeNumeral`
    /// - seealso: `makeInteger`
    /// - seealso: `makeUnsignedInteger`
    /// - precondition: `den != 0`
    public func makeReal(_ num: Int32, _ den: Int32) -> Z3Real {
        return Z3Real(context: self, ast: Z3_mk_real(context, num, den))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger(_ value: Int32) -> Z3Int {
        return Z3Int(context: self, ast: Z3_mk_int(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeIntegerBv(_ value: Int32) -> Z3Ast<BitVectorOfInt<Int32>> {
        return Z3Ast(context: self,
                     ast: Z3_mk_int(context, value, bitVectorSort(size: 32).sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine unsigned
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger(_ value: UInt32) -> Z3Int {
        return Z3Int(context: self, ast: Z3_mk_unsigned_int(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedIntegerBv(_ value: UInt32) -> Z3Ast<BitVectorOfInt<UInt32>> {
        return Z3Ast(context: self,
                     ast: Z3_mk_unsigned_int(context, value, bitVectorSort(size: 32).sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger64(_ value: Int64) -> Z3Int {
        return Z3Int(context: self, ast: Z3_mk_int64(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger64Bv(_ value: Int64) -> Z3Ast<BitVectorOfInt<Int64>> {
        return Z3Ast(context: self, ast: Z3_mk_int64(context, value, bitVectorSort(size: 64).sort))
    }

    /// Create a numeral of an int, bit-vector, or finite-domain sort.
    ///
    /// This method can be used to create numerals that fit in a machine `UInt64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger64(_ value: UInt64) -> Z3Int {
        return Z3Int(context: self, ast: Z3_mk_unsigned_int64(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger64Bv(_ value: UInt64) -> Z3Ast<BitVectorOfInt<UInt64>> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int64(context, value, bitVectorSort(size: 64).sort))
    }
}

internal extension Z3Context {
    /// Rethrows any current `errorCode` different from `Z3ErrorCode.ok`
    func rethrowCurrentErrorCodeIfAvailable() throws {
        if hasError {
            throw errorCode
        }
    }
}
