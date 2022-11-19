import CZ3

public extension Z3Context {
    // MARK: - Parser interface

    /// Parse the given string using the SMT-LIB2 parser.
    /// 
    /// It returns a formula comprising of the conjunction of assertions in the
    /// scope (up to push/pop) at the end of the string.
    func parseSmtlib2String(
        _ str: String,
        sorts: [(name: Z3Symbol, Z3Sort)],
        decls: [(name: Z3Symbol, Z3FuncDecl)]
    ) -> Z3AstVector {
        
        let sortsName = sorts.map(\.0).toZ3_symbolPointerArray()
        let sorts = sorts.map(\.1).toZ3_sortPointerArray()
        let declsName = decls.map(\.0).toZ3_symbolPointerArray()
        let decls = decls.map(\.1).toZ3_astPointerArray()
        
        return Z3AstVector(
            context: self,
            astVector: Z3_parse_smtlib2_string(
                context,
                str,
                UInt32(sorts.count), sortsName, sorts,
                UInt32(decls.count), declsName, decls
            )
        )
    }

    /// Parse the contents of a given file path using the SMT-LIB2 parser.
    /// 
    /// It returns a formula comprising of the conjunction of assertions in the
    /// scope (up to push/pop) at the end of the file.
    /// 
    /// Similar to `parseSmtlib2String(_:sorts:decls:)`, but reads the benchmark
    /// from a file.
    func parseSmtlib2File(
        filePath: String,
        sorts: [(name: Z3Symbol, Z3Sort)],
        decls: [(name: Z3Symbol, Z3FuncDecl)]
    ) throws -> Z3AstVector {
        
        let sortsName = sorts.map(\.0).toZ3_symbolPointerArray()
        let sorts = sorts.map(\.1).toZ3_sortPointerArray()
        let declsName = decls.map(\.0).toZ3_symbolPointerArray()
        let decls = decls.map(\.1).toZ3_astPointerArray()
        
        return Z3AstVector(
            context: self,
            astVector: Z3_parse_smtlib2_file(
                context,
                filePath,
                UInt32(sorts.count), sortsName, sorts,
                UInt32(decls.count), declsName, decls
            )
        )
    }

    /// Parse and evaluate and SMT-LIB2 command sequence. The state from a
    /// previous call is saved so the next evaluation builds on top of the
    /// previous call.
    func evalSmtlib2String(_ str: String) -> String {
        Z3_eval_smtlib2_string(context, str).toString()
    }

    /// Create a parser context.
    /// 
    /// A parser context maintains state between calls to `Z3ParserContext.parseString(_:)`
    /// where the caller can pass in a set of SMTLIB2 commands.
    /// It maintains all the declarations from previous calls together with of
    /// sorts and function declarations (including 0-ary) that are added directly
    /// to the context.
    func createParserContext() -> Z3ParserContext {
        return Z3ParserContext(
            context: self,
            parserCtx: Z3_mk_parser_context(context)
        )
    }
}
