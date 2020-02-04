import CZ3

public extension Z3Context {
    // MARK: - Constants and Applications

    ///  Declare a constant or function.
    ///
    /// - parameter name: name of the constant or function.
    /// - parameter domain: array containing the sort of each argument. Must be
    /// empty when declaring a constant.
    /// - parameter range: sort of the constant or the return sort of the function.
    ///
    /// After declaring a constant or function, the function `makeApp()` can be
    /// used to create a constant or function
    /// application.
    ///
    /// - seealso: `makeApply`
    /// - seealso: `makeFreshFuncDecl`
    /// - seealso: `makeRecFuncDecl`
    func makeFuncDecl(name: Z3Symbol, domain: [Z3Sort], range: Z3Sort) -> Z3FuncDecl {

        let domain = domain.toZ3_sortPointerArray()

        let decl =
            Z3_mk_func_decl(context, name.symbol, UInt32(domain.count),
                            domain, range.sort)

        return Z3FuncDecl(funcDecl: decl!)
    }

    // TODO: Add error handling to this method

    /// Create a constant or function application.
    ///
    /// - seealso: `makeFreshFuncDecl`
    /// - seealso: `makeFuncDecl`
    /// - seealso: `makeRecFuncDecl`
    func makeApply(_ decl: Z3FuncDecl, args: [AnyZ3Ast]) -> AnyZ3Ast {
        let args = args.toZ3_astPointerArray()

        let ast = Z3_mk_app(context, decl.funcDecl, UInt32(args.count), args)

        return AnyZ3Ast(context: self, ast: ast!)
    }

    /// Declare and create a constant.
    ///
    /// This function is a shorthand for:
    /// ```
    /// Z3_func_decl d = Z3_mk_func_decl(c, s, 0, 0, ty);
    /// Z3_ast n       = Z3_mk_app(c, d, 0, 0);
    /// ```
    func makeConstant(name: Z3Symbol, sort: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_const(context, name.symbol, sort.sort))
    }

    /// Declare and create a constant.
    ///
    /// This function is a shorthand for:
    /// ```
    /// let symbol = makeStringSymbol(name)
    /// let n = makeConstant(name: symbol, sort: sort.getSort(self)).castTo<T>()
    /// ```
    /// - seealso: `makeApply`
    /// - seealso: `makeFreshConst`
    /// - seealso: `makeFuncDecl`
    func makeConstant<T: SortKind>(name: String, sort: T.Type) -> Z3Ast<T> {
        let symbol = makeStringSymbol(name)

        return makeConstant(name: symbol, sort: sort.getSort(self)).castTo()
    }

    /// Declare a fresh constant or function.
    ///
    /// Z3 will generate an unique name for this function declaration.
    /// If prefix is different from `nil`, then the name generate by Z3 will
    /// start with `prefix`.
    ///
    /// - remark: If `prefix` is `nil`, then it is assumed to be the empty string.
    /// - seealso: `makeFuncDecl`
    func makeFreshFuncDecl(prefix: String?, domain: [Z3Sort], range: Z3Sort) -> Z3FuncDecl {
        let domain = domain.toZ3_sortPointerArray()

        let decl =
            Z3_mk_fresh_func_decl(context, prefix, UInt32(domain.count), domain, range.sort)

        return Z3FuncDecl(funcDecl: decl!)
    }


    /// Declare and create a fresh constant.
    ///
    /// This function is a shorthand for:
    /// ```
    /// Z3_func_decl d = Z3_mk_fresh_func_decl(c, prefix, 0, 0, ty);
    /// Z3_ast n = Z3_mk_app(c, d, 0, 0);
    /// ```
    ///
    /// - remark: If `prefix` is `nil`, then it is assumed to be the empty string.
    /// - seealso: `makeApply`
    /// - seealso: `makeConstant`
    /// - seealso: `makeFreshFuncDecl`
    /// - seealso: `makeFuncDecl`
    func makeFreshConstant(prefix: String?, sort: Z3Sort) -> AnyZ3Ast {
        let const =
            Z3_mk_fresh_const(context, prefix, sort.sort)

        return AnyZ3Ast(context: self, ast: const!)
    }

    ///  Declare a recursive function
    ///
    /// After declaring recursive function, it should be associated with a
    /// recursive definition `addRecDef`.
    /// The function `makeApply()` can be used to create a constant or function
    /// application.
    ///
    /// - parameter name: name of the function.
    /// - parameter domain: array containing the sort of each argument. The array must not be empty.
    /// - parameter range: sort of the constant or the return sort of the function.
    ///
    /// - seealso: `addRecDef`
    /// - seealso: `makeApply`
    /// - seealso: `makeFuncDecl`
    func makeRecFuncDecl(name: Z3Symbol, domain: [Z3Sort], range: Z3Sort) -> Z3FuncDecl {
        precondition(!domain.isEmpty)

        let domain = domain.toZ3_sortPointerArray()

        let decl =
            Z3_mk_rec_func_decl(context, name.symbol, UInt32(domain.count),
                                domain, range.sort)

        return Z3FuncDecl(funcDecl: decl!)
    }

    // TODO: Add error handling to the function bellow

    ///  Define the body of a recursive function.
    ///
    /// After declaring a recursive function or a collection of mutually
    /// recursive functions, use this function to provide the definition for the
    /// recursive function.
    ///
    /// - parameter f: function declaration.
    /// - parameter args: constants that are used as arguments to the recursive
    /// function in the definition.
    /// - parameter body: body of the recursive function
    /// - sealso: `makeRecFuncDecl`
    func addRecDef(_ f: Z3FuncDecl, args: [AnyZ3Ast], body: AnyZ3Ast) {
        var args = args.toZ3_astPointerArray()

        Z3_add_rec_def(context, f.funcDecl, UInt32(args.count),
                       &args, body.ast)
    }
}
