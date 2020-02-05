import CZ3

public class Z3Pattern {
    var context: Z3Context
    var pattern: Z3_pattern
    
    init(context: Z3Context, pattern: Z3_pattern) {
        self.context = context
        self.pattern = pattern
    }
}
