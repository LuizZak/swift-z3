import CZ3

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

    /// Return the error code for the last API call.
    public var errorCode: Z3ErrorCode {
        return .fromZ3_error_code(Z3_get_error_code(context))
    }

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context(configuration?.config)
    }

    deinit {
        Z3_del_context(context)
    }

    /// Return a string describing the given error code.
    public func errorMessage(_ code: Z3ErrorCode) -> String {
        return String(cString: Z3_get_error_msg(context, code.toZ3_error_code))
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
        return makeNumeral(number: number, sort: sort.getSort(self)).castTo()
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
    public func makeInteger(value: Int32) -> Z3Ast<IntSort> {
        return Z3Ast(context: self, ast: Z3_mk_int(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeIntegerBv(value: Int32) -> Z3Ast<BitVectorOfInt<Int32>> {
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
    public func makeUnsignedInteger(value: UInt32) -> Z3Ast<IntSort> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedIntegerBv(value: UInt32) -> Z3Ast<BitVectorOfInt<UInt32>> {
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
    public func makeInteger64(value: Int64) -> Z3Ast<IntSort> {
        return Z3Ast(context: self, ast: Z3_mk_int64(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeInteger64Bv(value: Int64) -> Z3Ast<BitVectorOfInt<Int64>> {
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
    public func makeUnsignedInteger64(value: UInt64) -> Z3Ast<IntSort> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int64(context, value, intSort().sort))
    }

    /// Create a numeral of a bit-vector.
    ///
    /// This method can be used to create numerals that fit in a machine `Int64`
    /// integer.
    /// It is slightly faster than makeNumeral since it is not necessary to
    /// parse a string.
    ///
    /// - seealso: `Z3_mk_numeral`
    public func makeUnsignedInteger64Bv(value: UInt64) -> Z3Ast<BitVectorOfInt<UInt64>> {
        return Z3Ast(context: self, ast: Z3_mk_unsigned_int64(context, value, bitVectorSort(size: 64).sort))
    }
}
