import CZ3

public class Z3Pattern: Z3AstBase {
    /// Alias for `ast`
    var pattern: Z3_pattern {
        return ast
    }
    
    init(context: Z3Context, pattern: Z3_pattern) {
        super.init(context: context, ast: pattern)
    }
    
    /// Translate/Copy the AST `self` from its current context to context `target`
    public override func translate(to newContext: Z3Context) -> Z3Pattern {
        if context === newContext {
            return self
        }

        let newAst = Z3_translate(context.context, ast, newContext.context)

        return Z3Pattern(context: newContext, pattern: newAst!)
    }
}

internal extension Sequence where Element: Z3Pattern {
    func toZ3_patternPointerArray() -> [Z3_pattern?] {
        return map { $0.pattern }
    }
}
