import CZ3

/// Main interaction point to Z3.
public class Z3Context {
    /// Indicates whether the current Z3_context associated with this Z3Context
    /// was borrowed from another live Z3Context instance. Used to avoid calling
    /// deinitializers on the borrowed pointer.
    private var _isBorrowed: Bool = false
    private var _cachedFpaRoundingMode: Z3_ast

    internal var context: Z3_context
    
    /// Gets or sets a reference to a rounding mode for floating-point operations
    /// performed on `Z3FloatingPoint` instances created by this context.
    ///
    /// Changes to this value change the rounding mode that is passed to the
    /// underlying `Z3_mk_fpa_*` methods that are generated via overloaded operators
    /// on `Z3FloatingPoint` instances.
    ///
    /// Defaults to NearestTiesToEven rounding mode, if not configured.
    public var currentFpaRoundingMode: Z3RoundingMode {
        get {
            return Z3RoundingMode(
                context: self,
                ast: _cachedFpaRoundingMode
            )
        }
        set {
            Z3_inc_ref(context, newValue.ast)
            Z3_dec_ref(context, _cachedFpaRoundingMode)

            _cachedFpaRoundingMode = newValue.ast
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

    /// Return the number of builtin probes available in Z3. 
    public var probeCount: UInt32 {
        Z3_get_num_probes(context)
    }

    /// Return the number of builtin tactics available in Z3.
    public var tacticCount: UInt32 {
        Z3_get_num_tactics(context)
    }

    public init(configuration: Z3Config? = nil) {
        context = Z3_mk_context_rc(configuration?.config)
        Z3_set_error_handler(context) { (context, code) in
            print("Z3 Error: \(Z3_get_error_msg(context, code).toString())")
        }

        _cachedFpaRoundingMode = Z3_mk_fpa_round_nearest_ties_to_even(context)
        Z3_inc_ref(context, _cachedFpaRoundingMode)
    }
    
    internal init(borrowing context: Z3_context) {
        self.context = context
        _isBorrowed = true

        _cachedFpaRoundingMode = Z3_mk_fpa_round_nearest_ties_to_even(context)
        Z3_inc_ref(context, _cachedFpaRoundingMode)
    }

    deinit {
        Z3_dec_ref(context, _cachedFpaRoundingMode)
        
        if !_isBorrowed {
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

    /// Select mode for the format used for pretty-printing AST nodes.
    /// 
    /// The default mode for pretty printing AST nodes is to produce SMT-LIB style
    /// output where common subexpressions are printed
    /// at each occurrence. The mode is called `Z3AstPrintMode.printSmtlibFull`.
    /// To print shared common subexpressions only once, use the
    /// `Z3AstPrintMode.printLowLevel` mode.
    /// To print in way that conforms to SMT-LIB standards and uses let expressions
    /// to share common sub-expressions use `Z3AstPrintMode.printSmtlib2Compliant`.
    public func setAstPrintMode(_ mode: Z3AstPrintMode) {
        Z3_set_ast_print_mode(context, mode)
    }

    /// Convert the given benchmark into SMT-LIB formatted string.
    /// 
    /// - parameters:
    ///   - name: - name of benchmark. The argument is optional.
    ///   - logic: - the benchmark logic.
    ///   - status: - the status string (sat, unsat, or unknown)
    ///   - attributes: - other attributes, such as source, difficulty or category.
    ///   - num_assumptions: - number of assumptions.
    ///   - assumptions: - auxiliary assumptions.
    ///   - formula: - formula to be checked for consistency in conjunction with assumptions.
    public func benchmarkToSmtlibString(
        name: String? = nil,
        logic: String,
        status: String,
        attributes: String,
        assumptions: [Z3AstBase],
        formula: Z3AstBase
    ) -> String {

        preparingArgsAst(assumptions) { (count, asts) in
            Z3_benchmark_to_smtlib_string(
                context,
                name,
                logic,
                status,
                attributes,
                count,
                asts,
                formula.ast
            ).toString()
        }
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
