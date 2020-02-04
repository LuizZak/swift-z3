import CZ3

public extension Z3Context {
    /// Array read.
    ///
    /// The argument `a` is the array and `i` is the index of the array that
    /// gets read.
    ///
    /// The node `a` must have an array sort `[domain -> range]`, and `i` must
    /// have the sort `domain`. The sort of the result is `range`.
    ///
    /// - `makeArraySort`
    /// - `makeStore`
    func makeSelect<D, R>(_ a: Z3Array<D, R>, _ i: Z3Ast<D>) -> Z3Ast<R> {
        return Z3Ast(context: self, ast: Z3_mk_select(context, a.ast, i.ast))
    }

    /// Array read.
    ///
    /// Type-erased version.
    ///
    /// The argument `a` is the array and `i` is the index of the array that
    /// gets read.
    ///
    /// The node `a` must have an array sort `[domain -> range]`, and `i` must
    /// have the sort `domain`. The sort of the result is `range`.
    ///
    /// - `makeArraySort`
    /// - `makeStore`
    func makeSelectAny(_ a: AnyZ3Ast, _ i: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_select(context, a.ast, i.ast))
    }

    /// n-ary Array read.
    ///
    /// The argument `a` is the array and `idxs` are the indices of the array
    /// that gets read.
    func makeSelectN<D, R>(_ a: Z3Array<D, R>, _ idxs: [Z3Ast<D>]) -> AnyZ3Ast {
        let idxs = idxs.toZ3_astPointerArray()

        return AnyZ3Ast(context: self, ast: Z3_mk_select_n(context, a.ast, UInt32(idxs.count), idxs))
    }

    /// n-ary Array read.
    ///
    /// Type-erased version.
    ///
    /// The argument `a` is the array and `idxs` are the indices of the array
    /// that gets read.
    func makeSelectNAny(_ a: AnyZ3Ast, _ idxs: [AnyZ3Ast]) -> AnyZ3Ast {
        let idxs = idxs.toZ3_astPointerArray()

        return AnyZ3Ast(context: self, ast: Z3_mk_select_n(context, a.ast, UInt32(idxs.count), idxs))
    }

    /// Array update.
    ///
    /// The node `a` must have an array sort `[domain -> range]`, `i` must have
    /// sort `domain`, `v` must have sort range. The sort of the result is
    /// `[domain -> range]`.
    /// The semantics of this function is given by the theory of arrays described
    /// in the SMT-LIB standard. See http://smtlib.org for more details.
    /// The result of this function is an array that is equal to `a` (with respect
    /// to `select`) on all indices except for `i`, where it maps to `v` (and
    /// the `select` of `a` with respect to `i` may be a different value).
    func makeStore<D, R>(_ a: Z3Array<D, R>, _ i: Z3Ast<D>, _ v: Z3Ast<R>) -> Z3Array<D, R> {
        return Z3Ast(context: self, ast: Z3_mk_store(context, a.ast, i.ast, v.ast))
    }

    /// Array update.
    ///
    /// Type-erased version.
    ///
    /// The node `a` must have an array sort `[domain -> range]`, `i` must have
    /// sort `domain`, `v` must have sort range. The sort of the result is
    /// `[domain -> range]`.
    /// The semantics of this function is given by the theory of arrays described
    /// in the SMT-LIB standard. See http://smtlib.org for more details.
    /// The result of this function is an array that is equal to `a` (with respect
    /// to `select`) on all indices except for `i`, where it maps to `v` (and
    /// the `select` of `a` with respect to `i` may be a different value).
    func makeStoreAny(_ a: AnyZ3Ast, _ i: AnyZ3Ast, _ v: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_store(context, a.ast, i.ast, v.ast))
    }

    /// n-ary Array update.
    func makeStoreN<D, R>(_ a: Z3Array<D, R>, _ idxs: [Z3Ast<D>], _ v: Z3Ast<R>) -> Z3Array<D, R> {
        let idxs = idxs.toZ3_astPointerArray()

        return Z3Ast(context: self, ast: Z3_mk_store_n(context, a.ast, UInt32(idxs.count), idxs, v.ast))
    }

    /// n-ary Array update.
    ///
    /// Type-erased version
    func makeStoreNAny(_ a: AnyZ3Ast, _ idxs: [AnyZ3Ast], _ v: AnyZ3Ast) -> AnyZ3Ast {
        let idxs = idxs.toZ3_astPointerArray()

        return AnyZ3Ast(context: self, ast: Z3_mk_store_n(context, a.ast, UInt32(idxs.count), idxs, v.ast))
    }

    /// Create the constant array.
    ///
    /// The resulting term is an array, such that a `select` on an arbitrary
    /// index produces the value `value`.
    func makeConstArray<D, R>(_ value: Z3Ast<R>) -> Z3Array<D, R> {
        return makeConstArrayAny(D.getSort(self), value).castTo()
    }

    /// Create the constant array.
    ///
    /// Type-erased version
    ///
    /// The resulting term is an array, such that a `select` on an arbitrary
    /// index produces the value `value`.
    func makeConstArrayAny(_ domain: Z3Sort, _ value: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_const_array(context, domain.sort, value.ast))
    }

    /// Map f on the argument arrays.
    ///
    /// The `n` nodes `args` must be of array sorts `[domain_i -> range_i]`.
    /// The function declaration `f` must have type `range_1 .. range_n -> range`.
    /// `v` must have sort range. The sort of the result is `[domain_i -> range]`.
    ///
    /// - seealso: `makeArraySort`
    /// - seealso: `makeStore`
    /// - seealso: `makeSelect`
    func makeMap(_ f: Z3FuncDecl, args: [AnyZ3Ast]) -> AnyZ3Ast {
        let args = args.toZ3_astPointerArray()

        let result
            = Z3_mk_map(context, f.funcDecl, UInt32(args.count), args)

        return AnyZ3Ast(context: self, ast: result!)
    }

    /// Access the array default value.
    /// Produces the default range value, for arrays that can be represented as
    /// finite maps with a default range value.
    ///
    /// - parameter array: array value whose default range value is accessed.
    func makeArrayDefault<D, R>(_ array: Z3Array<D, R>) -> Z3Ast<R> {
        return Z3Ast(context: self, ast: Z3_mk_array_default(context, array.ast))
    }

    /// Access the array default value.
    /// Produces the default range value, for arrays that can be represented as
    /// finite maps with a default range value.
    ///
    /// Type-erased version.
    ///
    /// - parameter array: array value whose default range value is accessed.
    func makeArrayDefaultAny(_ array: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_array_default(context, array.ast))
    }

    /// Create array with the same interpretation as a function.
    /// The array satisfies the property `(f x) = (select (_ as-array f) x)`
    /// for every argument `x`.
    func makeAsArray(_ f: Z3FuncDecl) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_as_array(context, f.funcDecl))
    }

    /// Create predicate that holds if Boolean array `set` has `k` elements set
    /// to true.
    func makeSetHasSize<T>(_ set: Z3Set<T>, _ k: AnyZ3Ast) -> Z3Bool {
        return Z3Ast(context: self, ast: Z3_mk_set_has_size(context, set.ast, k.ast))
    }
}
