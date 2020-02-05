import CZ3

public class AnyZ3Ast {
    internal var context: Z3Context
    internal var ast: Z3_ast

    /// Return a unique identifier for this AST.
    ///
    /// The identifier is unique up to structural equality. Thus, two ast nodes
    /// created by the same context and having the same children and same
    /// function symbols have the same identifiers. Ast nodes created in the
    /// same context, but having different children or different functions have
    /// different identifiers.
    /// Variables and quantifiers are also assigned different identifiers
    /// according to their structure.
    public var id: UInt32 {
        return Z3_get_ast_id(context.context, ast)
    }

    /// Return a hash code for this AST.
    ///
    /// The hash code is structural. You can use `AnyZ3Ast.id` interchangeably
    /// with this function.
    public var hash: UInt32 {
        return Z3_get_ast_hash(context.context, ast)
    }

    /// Return the sort of this AST node.
    ///
    /// The AST node must be a constant, application, numeral, bound variable,
    /// or quantifier.
    public var sort: Z3Sort? {
        return Z3_get_sort(context.context, ast).map(Z3Sort.init(sort:))
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

    /// Return the kind of the given AST.
    public var astKind: Z3AstKind {
        return Z3AstKind.fromZ3_ast_kind(Z3_get_ast_kind(context.context, ast))
    }

    public var isApp: Bool {
        return Z3_is_app(context.context, ast)
    }

    public var isNumeralAst: Bool {
        return Z3_is_numeral_ast(context.context, ast)
    }

    /// Return `true` if this AST is a real algebraic number.
    public var isAlgebraicNumber: Bool {
        return Z3_is_algebraic_number(context.context, ast)
    }

    /// Return numeral value, as a string of a numeric constant term
    ///
    /// - precondition: `astKind == Z3AstKind.numeralAst`
    public var numeralString: String {
        return String(cString: Z3_get_numeral_string(context.contet, ast))
    }

    /// Return numeral as a double.
    ///
    /// - precondition: `astKind == Z3AstKind.numeralAst`
    public var numeralDouble: Double {
        return Z3_get_numeral_double(context.context, ast)
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

    init(context: Z3Context, ast: Z3_ast) {
        self.context = context
        self.ast = ast
    }
    
    /// An unsafe cast from a generic `AnyZ3Ast` or a specialized `Z3Ast` to
    /// another specialized `Z3Ast` type
    public func castTo<T: SortKind>(type: T.Type = T.self) -> Z3Ast<T> {
        return Z3Ast<T>(context: context, ast: ast)
    }
}

public class Z3Ast<T: SortKind>: AnyZ3Ast {
    
}

internal extension Sequence where Element: AnyZ3Ast {
    func toZ3_astPointerArray() -> [Z3_ast?] {
        return map { $0.ast }
    }
}

public typealias Z3Array<D: SortKind, R: SortKind> = Z3Ast<ArraySort<D, R>>
public typealias Z3Set<T: SortKind> = Z3Ast<SetSort<T>>
public typealias Z3Bool = Z3Ast<Bool>
public typealias Z3Float = Z3Ast<Float>
public typealias Z3Double = Z3Ast<Double>
