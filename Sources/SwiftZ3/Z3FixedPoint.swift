import CZ3

/// Context for the recursive predicate solver.
public class Z3FixedPoint: Z3RefCountedObject {
    public let context: Z3Context
    let fixedPoint: Z3_fixedpoint

    init(context: Z3Context, fixedPoint: Z3_fixedpoint) {
        self.context = context
        self.fixedPoint = fixedPoint
    }

    override func incRef() {
        Z3_fixedpoint_inc_ref(context.context, fixedPoint)
    }

    override func decRef() {
        Z3_fixedpoint_inc_ref(context.context, fixedPoint)
    }

    /// Add a universal Horn clause as a named rule.
    /// The `horn_rule` should be of the form:
    ///
    /// ```
    /// horn_rule ::= (forall (bound-vars) horn_rule)
    ///            |  (=> atoms horn_rule)
    ///            |  atom
    /// ```
    public func addRule(_ rule: Z3Bool, name: Z3Symbol? = nil) {
        Z3_fixedpoint_add_rule(
            context.context,
            fixedPoint,
            rule.ast,
            name?.symbol
        )
    }

    /// Add a Database fact.
    /// 
    /// - parameters:
    ///   - predicate: - relation signature for the row.
    ///   - args: - array of the row elements.
    /// 
    /// The number of arguments in `args` should be equal to the number of
    /// sorts in the domain of `predicate`. Each sort in the domain should be an
    /// integral (bit-vector, Boolean or or finite domain sort).
    /// 
    /// The call has the same effect as adding a rule where `predicate` is
    /// applied to the arguments.
    public func addFact(_ predicate: Z3FuncDecl, args: [UInt32]) {
        var args = args

        Z3_fixedpoint_add_fact(
            context.context,
            fixedPoint,
            predicate.funcDecl,
            UInt32(args.count),
            &args
        )
    }

    /// Assert a constraint to the fixedpoint context.
    ///
    /// The constraints are used as background axioms when the fixedpoint engine
    /// uses the PDR mode.
    /// They are ignored for standard Datalog mode.
    public func assert(_ axiom: Z3Bool) {
        Z3_fixedpoint_assert(
            context.context,
            fixedPoint,
            axiom.ast
        )
    }

    /// Pose a query against the asserted rules.
    ///
    /// ```
    /// query ::= (exists (bound-vars) query)
    ///       |  literals
    /// ```
    ///
    /// - returns:
    ///   - `Z3LBool.lFalse`: if the query is unsatisfiable.
    ///   - `Z3LBool.lTrue`: if the query is satisfiable. Obtain the answer by
    /// calling `getAnswer()`.
    ///   - `Z3LBool.lUndef`: if the query was interrupted, timed out or otherwise failed.
    public func query(_ query: Z3Bool) -> Z3LBool {
        Z3_fixedpoint_query(
            context.context,
            fixedPoint,
            query.ast
        )
    }

    /// Pose multiple queries against the asserted rules.
    ///
    /// The queries are encoded as relations (function declarations).
    ///
    /// - returns:
    ///   - `Z3LBool.lFalse`: if the query is unsatisfiable.
    ///   - `Z3LBool.lTrue`: if the query is satisfiable. Obtain the answer by
    /// calling `getAnswer()`.
    ///   - `Z3LBool.lUndef`: if the query was interrupted, timed out or otherwise failed.
    public func query(_ relations: [Z3FuncDecl]) -> Z3LBool {
        let pointers = relations.toZ3_astPointerArray()

        return Z3_fixedpoint_query_relations(
            context.context,
            fixedPoint,
            UInt32(pointers.count),
            pointers
        )
    }

    /// Retrieve a formula that encodes satisfying answers to the query.
    /// 
    /// 
    /// When used in Datalog mode, the returned answer is a disjunction of conjuncts.
    /// Each conjunct encodes values of the bound variables of the query that
    /// are satisfied.
    /// In PDR mode, the returned answer is a single conjunction.
    /// 
    /// When used in Datalog mode the previous call to `query(_:)` must have
    /// returned `Z3LBool.lTrue`.
    /// When used with the PDR engine, the previous call must have been either
    /// `Z3LBool.lTrue` or `Z3LBool.lFalse`.
    public func getAnswer() -> AnyZ3Ast {
        AnyZ3Ast(
            context: context,
            ast: Z3_fixedpoint_get_answer(
                context.context,
                fixedPoint
            )
        )
    }

    /// Retrieve a string that describes the last status returned by `query(_:)`.
    ///
    /// Use this method when `query(_:)` returns `Z3LBool.lUndef`.
    public func getReasonUnknown() -> String {
        Z3_fixedpoint_get_reason_unknown(
            context.context,
            fixedPoint
        ).toString()
    }

    /// Update a named rule.
    /// A rule with the same name must have been previously created.
    ///
    /// - seealso: `addRule(_:name:)`
    public func updateRule(_ rule: Z3Bool, name: Z3Symbol) {
        Z3_fixedpoint_update_rule(
            context.context,
            fixedPoint,
            rule.ast,
            name.symbol
        )
    }

    /// Query the PDR engine for the maximal levels properties are known about predicate.
    /// 
    /// This call retrieves the maximal number of relevant unfoldings
    /// of \c pred with respect to the current exploration state.
    /// Note: this functionality is PDR specific.
    public func getNumLevels(_ predicate: Z3FuncDecl) -> UInt32 {
        Z3_fixedpoint_get_num_levels(
            context.context,
            fixedPoint,
            predicate.funcDecl
        )
    }

    /// Retrieve the current cover of \c pred up to \c level unfoldings.
    /// Return just the delta that is known at \c level. To
    /// obtain the full set of properties of \c pred one should query
    /// at \c level+1 , \c level+2 etc, and include \c level=-1.
    /// 
    /// Note: this functionality is PDR specific.
    public func getCoverDelta(level: Int, predicate: Z3FuncDecl) -> AnyZ3Ast {
        AnyZ3Ast(
            context: context,
            ast: Z3_fixedpoint_get_cover_delta(
                context.context,
                fixedPoint,
                Int32(level),
                predicate.funcDecl
            )
        )
    }

    /// Retrieve the current cover of \c pred up to \c level unfoldings.
    /// Return just the delta that is known at \c level. To
    /// obtain the full set of properties of \c pred one should query
    /// at \c level+1 , \c level+2 etc, and include \c level=-1.
    /// 
    /// Note: this functionality is PDR specific.
    public func addCover(level: Int, predicate: Z3FuncDecl, property: AnyZ3Ast) {
        Z3_fixedpoint_add_cover(
            context.context,
            fixedPoint,
            Int32(level),
            predicate.funcDecl,
            property.ast
        )
    }

    /// Retrieve statistics information from the last call to `query(_:)`
    public func getStatistics() -> Z3Stats {
        Z3Stats(
            context: context,
            stats: Z3_fixedpoint_get_statistics(context.context, fixedPoint)
        )
    }

    /// \brief Register relation as Fixedpoint defined.
    /// Fixedpoint defined relations have least-fixedpoint semantics.
    /// For example, the relation is empty if it does not occur
    /// in a head or a fact.
    public func registerRelation(_ decl: Z3FuncDecl) {
        Z3_fixedpoint_register_relation(
            context.context,
            fixedPoint,
            decl.funcDecl
        )
    }

    /// Configure the predicate representation.
    /// 
    /// It sets the predicate to use a set of domains given by the list of symbols.
    /// The domains given by the list of symbols must belong to a set
    /// of built-in domains.
    public func setPredicateRepresentation(_ f: Z3FuncDecl, kinds: [Z3Symbol]) {
        let pointers = kinds.toZ3_symbolPointerArray()

        Z3_fixedpoint_set_predicate_representation(
            context.context,
            fixedPoint,
            f.funcDecl,
            UInt32(pointers.count),
            pointers
        )
    }

    /// Retrieve set of rules from fixedpoint context.
    public func getRules() -> Z3AstVector {
        return Z3AstVector(
            context: context,
            astVector: Z3_fixedpoint_get_rules(
                context.context, fixedPoint
            )
        )
    }

    /// Retrieve set of background assertions from fixedpoint context.
    public func getAssertions() -> Z3AstVector {
        return Z3AstVector(
            context: context,
            astVector: Z3_fixedpoint_get_assertions(
                context.context,
                fixedPoint
            )
        )
    }

    /// Set parameters on fixedpoint context.
    /// - seealso: `getHelp()`
    /// - seealso: `getParamDescrs()`
    public func setParams(_ p: Z3Params) {
        Z3_fixedpoint_set_params(
            context.context,
            fixedPoint,
            p.params
        )
    }

    /// Return a string describing all fixedpoint available parameters.
    /// - seealso: `getParamDescrs()`
    /// - seealso: `setParams(_:)`
    public func getHelp() -> String {
        return Z3_fixedpoint_get_help(
            context.context, 
            fixedPoint
        ).toString()
    }

    /// Return the parameter description set for the given fixedpoint object.
    /// - seealso: `getHelp()`
    /// - seealso: `setParams(_:)`
    public func getParamDescrs() -> Z3ParamDescrs {
        return Z3ParamDescrs(
            context: context,
            descr: Z3_fixedpoint_get_param_descrs(
                context.context,
                fixedPoint
            )
        )
    }
}
