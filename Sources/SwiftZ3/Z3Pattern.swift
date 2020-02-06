import CZ3

public class Z3Pattern: Z3AstBase {
    /// Alias for `ast`
    var pattern: Z3_pattern {
        return ast
    }
    
    init(context: Z3Context, pattern: Z3_pattern) {
        super.init(context: context, ast: pattern)
    }
}
