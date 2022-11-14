import CZ3

public extension Z3Context {
    /// Create Set type.
    func makeSetSort(_ ty: Z3Sort) -> Z3Sort {
        return Z3Sort(context: self, sort: Z3_mk_set_sort(context, ty.sort))
    }

    /// Create the empty set.
    func makeEmptySet<T: SortKind>(_ domain: T.Type) -> Z3Set<T> {
        return Z3Set(context: self, ast: Z3_mk_empty_set(context, domain.getSort(self).sort))
    }

    /// Create the empty set.
    ///
    /// Type-erased version.
    func makeEmptySetAny(_ domain: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_empty_set(context, domain.sort))
    }

    /// Create the full set.
    func makeFullSet<T: SortKind>(_ domain: T.Type) -> Z3Set<T> {
        return Z3Set(context: self, ast: Z3_mk_full_set(context, domain.getSort(self).sort))
    }

    /// Create the full set.
    ///
    /// Type-erased version.
    func makeFullSet(_ domain: Z3Sort) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_full_set(context, domain.sort))
    }

    /// Add an element to a set.
    func makeSetAdd<T: SortKind>(_ set: Z3Set<T>, element: Z3Ast<T>) -> Z3Set<T> {
        return Z3Set(context: self, ast: Z3_mk_set_add(context, set.ast, element.ast))
    }

    /// Add an element to a set.
    ///
    /// Type-erased version
    func makeSetAddAny(_ set: AnyZ3Ast, element: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_set_add(context, set.ast, element.ast))
    }

    /// Remove an element from a set
    func makeSetDel<T: SortKind>(_ set: Z3Set<T>, element: Z3Ast<T>) -> Z3Set<T> {
        return Z3Set(context: self, ast: Z3_mk_set_del(context, set.ast, element.ast))
    }

    /// Remove an element from a set
    ///
    /// Type-erased version
    func makeSetDelAny(_ set: AnyZ3Ast, element: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_set_del(context, set.ast, element.ast))
    }

    /// Take the union of a list of sets
    func makeSetUnion<T: SortKind>(_ sets: [Z3Set<T>]) -> Z3Set<T> {
        let sets = sets.toZ3_astPointerArray()

        return Z3Set(context: self, ast: Z3_mk_set_union(context, UInt32(sets.count), sets))
    }

    /// Take the union of a list of sets
    ///
    /// Type-erased version
    func makeSetUnionAny(_ sets: [Z3AstBase]) -> AnyZ3Ast {
        let sets = sets.toZ3_astPointerArray()

        return AnyZ3Ast(context: self, ast: Z3_mk_set_union(context, UInt32(sets.count), sets))
    }

    /// Take the intersection of a list of sets
    func makeSetIntersect<T: SortKind>(_ sets: [Z3Set<T>]) -> Z3Set<T> {
        let sets = sets.toZ3_astPointerArray()

        return Z3Set(context: self, ast: Z3_mk_set_intersect(context, UInt32(sets.count), sets))
    }

    /// Take the intersection of a list of sets
    ///
    /// Type-erased version
    func makeSetIntersectAny(_ sets: [AnyZ3Ast]) -> AnyZ3Ast {
        let sets = sets.toZ3_astPointerArray()

        return AnyZ3Ast(context: self, ast: Z3_mk_set_intersect(context, UInt32(sets.count), sets))
    }

    /// Take the different between two sets.
    func makeSetDifference<T: SortKind>(_ arg1: Z3Set<T>, _ arg2: Z3Set<T>) -> Z3Set<T> {
        return Z3Set(context: self, ast: Z3_mk_set_difference(context, arg1.ast, arg2.ast))
    }

    /// Take the different between two sets.
    ///
    /// Type-erased version.
    func makeSetDifferenceAny(_ arg1: AnyZ3Ast, _ arg2: AnyZ3Ast) -> AnyZ3Ast {
        return AnyZ3Ast(context: self, ast: Z3_mk_set_difference(context, arg1.ast, arg2.ast))
    }

    /// Check for set membership.
    func makeSetMember<T: SortKind>(element: Z3Ast<T>, set: Z3Set<T>) -> Z3Bool {
        return Z3Bool(context: self, ast: Z3_mk_set_member(context, element.ast, set.ast))
    }

    /// Check for set membership.
    ///
    /// Type-erased version.
    func makeSetMemberAny(element: AnyZ3Ast, set: AnyZ3Ast) -> Z3Bool {
        return Z3Bool(context: self, ast: Z3_mk_set_member(context, element.ast, set.ast))
    }

    /// Check for subset-ness of sets
    func makeSetSubset<T: SortKind>(_ arg1: Z3Set<T>, _ arg2: Z3Set<T>) -> Z3Bool {
        return Z3Bool(context: self, ast: Z3_mk_set_subset(context, arg1.ast, arg2.ast))
    }

    /// Check for subset-ness of sets
    ///
    /// Type-erased version.
    func makeSetSubsetAny(_ arg1: AnyZ3Ast, _ arg2: AnyZ3Ast) -> Z3Bool {
        return Z3Bool(context: self, ast: Z3_mk_set_subset(context, arg1.ast, arg2.ast))
    }
}
