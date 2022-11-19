import CZ3

/// A function declaration node.
public class Z3FuncDecl: Z3AstBase {
    /// Alias for `ast`
    var funcDecl: Z3_func_decl {
        ast
    }
    
    /// Return the number of parameters of the function declaration.
    ///
    /// - seealso: `domainSize`
    public var arity: UInt32 {
        return Z3_get_arity(context.context, funcDecl)
    }
    
    /// Return the number of parameters of the function declaration.
    ///
    /// - seealso: `domainSize`
    public var domainSize: UInt32 {
        return Z3_get_domain_size(context.context, funcDecl)
    }
    
    /// Return the domain of the function declaration
    public var domain: [Z3Sort] {
        var sort: [Z3_sort?] = Array(repeating: nil, count: Int(domainSize))
        for i in 0..<domainSize {
            sort[Int(i)] = Z3_get_domain(context.context, funcDecl, i)
        }
        
        return sort.toZ3SortArray(context: context)
    }
    
    /// Return the range of the function declaration.
    public var range: Z3Sort {
        return Z3Sort(context: context, sort: Z3_get_range(context.context, funcDecl))
    }
    
    /// Return the name of the function declaration.
    public var name: Z3Symbol {
        return Z3Symbol(context: context, symbol: Z3_get_decl_name(context.context, funcDecl))
    }
    
    /// Return the number of parameters associated with the function declaration
    public var parametersCount: UInt32 {
        return Z3_get_decl_num_parameters(context.context, funcDecl)
    }

    init(context: Z3Context, funcDecl: Z3_func_decl) {
        super.init(context: context, ast: funcDecl)
    }
    
    /// Convert the current AST node into a string.
    public override func toString() -> String {
        return String(cString: Z3_func_decl_to_string(context.context, ast))
    }

    /// Translate/Copy the AST `self` from its current context to context `target`
    public override func translate(to newContext: Z3Context) -> Z3FuncDecl {
        if context === newContext {
            return self
        }

        let newAst = Z3_translate(context.context, ast, newContext.context)

        return Z3FuncDecl(context: newContext, funcDecl: newAst!)
    }
}

internal extension Sequence where Element == Z3_func_decl {
    func toZ3FuncDeclArray(context: Z3Context) -> [Z3FuncDecl] {
        return map { Z3FuncDecl(context: context, funcDecl: $0) }
    }
}

internal extension Sequence where Element == Z3_func_decl? {
    func toZ3FuncDeclArray(context: Z3Context) -> [Z3FuncDecl] {
        return map { Z3FuncDecl(context: context, funcDecl: $0!) }
    }
}
