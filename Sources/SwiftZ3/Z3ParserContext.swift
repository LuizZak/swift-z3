import CZ3

public class Z3ParserContext {
    /// The context this `Z3ParserContext` belongs
    public let context: Z3Context
    let parserCtx: Z3_parser_context
    
    init(context: Z3Context, parserCtx: Z3_parser_context) {
        self.context = context
        self.parserCtx = parserCtx
        
        Z3_parser_context_inc_ref(context.context, parserCtx)
    }
    
    deinit {
        Z3_parser_context_dec_ref(context.context, parserCtx)
    }

    /// Add a sort declaration.
    public func addSort(_ sort: Z3Sort) {
        Z3_parser_context_add_sort(
            context.context,
            parserCtx,
            sort.sort
        )
    }

    /// Add a function declaration.
    public func addDecl(_ decl: Z3FuncDecl) {
        Z3_parser_context_add_sort(
            context.context,
            parserCtx,
            decl.funcDecl
        )
    }

    /// Parse a string of SMTLIB2 commands. Return assertions.
    public func parseString(_ str: String) -> Z3AstVector {
        Z3AstVector(
            context: context,
            astVector: Z3_parser_context_from_string(
                context.context,
                parserCtx,
                str
            )
        )
    }
}
