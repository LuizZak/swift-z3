import Z3

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
    func makeSelect<D, R>(_ a: Z3Ast<ArraySort<D, R>>, _ i: Z3Ast<D>) -> Z3Ast<R> {
        return Z3Ast(context: self, ast: Z3_mk_select(context, a.ast, i.ast))
    }

    /// Array read.
    ///
    /// Type-erased overload.
    ///
    /// The argument `a` is the array and `i` is the index of the array that
    /// gets read.
    ///
    /// The node `a` must have an array sort `[domain -> range]`, and `i` must
    /// have the sort `domain`. The sort of the result is `range`.
    ///
    /// - `makeArraySort`
    /// - `makeStore`
    func makeSelect(_ a: AnyZ3Ast, _ i: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_select(context, a.ast, i.ast))
    }

    /// n-ary Array read.
    ///
    /// The argument `a` is the array and `idxs` are the indices of the array
    /// that gets read.
    func makeSelectN<D, R>(_ a: Z3Ast<ArraySort<D, R>>, _ idxs: [Z3Ast<D>]) -> AnyZ3Ast {
        let idxs = idxs.toZ3_astPointerArray()

        return AnyZ3Ast(context: self, ast: Z3_mk_select_n(context, a.ast, UInt32(idxs.count), idxs))
    }

    /// n-ary Array read.
    ///
    /// Type-erased overload.
    ///
    /// The argument `a` is the array and `idxs` are the indices of the array
    /// that gets read.
    func makeSelectN(_ a: AnyZ3Ast, _ idxs: [AnyZ3Ast]) -> AnyZ3Ast {
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
    func makeStore<D, R>(_ a: Z3Ast<ArraySort<D, R>>, _ i: Z3Ast<D>, _ v: Z3Ast<R>) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_store(context, a.ast, i.ast, v.ast))
    }

    /// Array update.
    ///
    /// Type-erased overload.
    ///
    /// The node `a` must have an array sort `[domain -> range]`, `i` must have
    /// sort `domain`, `v` must have sort range. The sort of the result is
    /// `[domain -> range]`.
    /// The semantics of this function is given by the theory of arrays described
    /// in the SMT-LIB standard. See http://smtlib.org for more details.
    /// The result of this function is an array that is equal to `a` (with respect
    /// to `select`) on all indices except for `i`, where it maps to `v` (and
    /// the `select` of `a` with respect to `i` may be a different value).
    func makeStore(_ a: AnyZ3Ast, _ i: AnyZ3Ast, _ v: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_store(context, a.ast, i.ast, v.ast))
    }

    /// n-ary Array update.
    func makeStore<D, R>(_ a: Z3Ast<ArraySort<D, R>>, _ idxs: [Z3Ast<D>], _ v: Z3Ast<R>) -> AnyZ3Ast {
        let idxs = idxs.toZ3_astPointerArray()

        return AnyZ3Ast(context: self, ast: Z3_mk_store_n(context, a.ast, UInt32(idxs.count), idxs, v.ast))
    }

    /// Create the constant array.
    ///
    /// The resulting term is an array, such that a `select` on an arbitrary
    /// index produces the value `value`.
    func makeConstArray<D, R>(_ value: Z3Ast<R>) -> Z3Ast<ArraySort<D, R>> {
        return Z3Ast(context: self, ast: Z3_mk_const_array(context, D.getSort(self).sort, value.ast))
    }

    /// Create the constant array.
    ///
    /// Type-erased overload
    ///
    /// The resulting term is an array, such that a `select` on an arbitrary
    /// index produces the value `value`.
    func makeConstArray(_ domain: Z3Sort, _ value: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_const_array(context, domain.sort, value.ast))
    }
}
