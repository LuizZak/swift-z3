import CZ3

public class AnyZ3Ast: Z3AstBase {
    /// Return the sort of this AST node.
    ///
    /// The AST node must be a constant, application, numeral, bound variable,
    /// or quantifier.
    public var sort: Z3Sort? {
        return Z3_get_sort(context.context, ast).map { Z3Sort(context: context, sort: $0) }
    }

    /// Return `true` if this expression is well sorted.
    public var isWellSorted: Bool {
        return Z3_is_well_sorted(context.context, ast)
    }

    /// Returns `true` if this AST is true, `false` if this AST is false, and `nil`
    /// otherwise
    public var boolValue: Bool? {
        switch Z3_get_bool_value(context.context, ast) {
        case Z3_L_TRUE:
            return true
        case Z3_L_FALSE:
            return false
        default:
            return nil
        }
    }

    /// Return numeral value, as a string of a numeric constant term
    ///
    /// - precondition: `astKind == Z3AstKind.numeralAst`
    public var numeralString: String {
        return String(cString: Z3_get_numeral_string(context.context, ast))
    }

    /// Return numeral as a double.
    ///
    /// - precondition: `astKind == Z3AstKind.numeralAst`
    public var numeralDouble: Double {
        return Z3_get_numeral_double(context.context, ast)
    }

    /// Return numeral as an integer.
    ///
    /// - precondition: `astKind == Z3AstKind.numeralAst`
    public var numeralInt: Int32 {
        var i: Int32 = 0
        Z3_get_numeral_int(context.context, ast, &i)
        return i
    }

    /// Return the numerator (as a numeral AST) of a numeral AST of sort Real.
    ///
    /// - precondition: `astKind == Z3AstKind.numeralAst`
    public var numerator: AnyZ3Ast? {
        return Z3_get_numerator(context.context, ast).map { AnyZ3Ast(context: context, ast: $0) }
    }

    /// Return the denominator (as a numeral AST) of a numeral AST of sort Real.
    ///
    /// - precondition: `astKind == Z3AstKind.numeralAst`
    public var denominator: AnyZ3Ast? {
        return Z3_get_denominator(context.context, ast).map { AnyZ3Ast(context: context, ast: $0) }
    }

    /// Determine if an ast is a universal quantifier.
    public var quantifierForAll: Bool {
        return Z3_is_quantifier_forall(context.context, ast)
    }

    /// Determine if ast is an existential quantifier.
    public var quantifierExists: Bool {
        return Z3_is_quantifier_exists(context.context, ast)
    }

    /// Determine if ast is a lambda expression.
    ///
    /// - precondition: `astKind == Z3AstKind.quantifierAst`
    public var isLambda: Bool {
        return Z3_is_lambda(context.context, ast)
    }

    /// Compares this term to another term.
    public func isEqual(to other: AnyZ3Ast) -> Bool {
        return Z3_is_eq_ast(context.context, ast, other.ast)
    }

    /// Translate/Copy the AST `self` from its current context to context `target`
    public override func translate(to target: Z3Context) -> AnyZ3Ast {
        if context === target {
            return self
        }

        let newAst = Z3_translate(context.context, ast, target.context)

        return AnyZ3Ast(context: target, ast: newAst!)
    }
}

internal extension Sequence where Element: AnyZ3Ast {
    func toZ3_astPointerArray() -> [Z3_ast?] {
        return map { $0.ast }
    }
}
