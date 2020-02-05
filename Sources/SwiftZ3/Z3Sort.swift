import CZ3

public class Z3Sort {
    var context: Z3Context
    var sort: Z3_sort

    /// Return the sort name as a symbol.
    public var sortName: Z3Symbol {
        return Z3Symbol(context: context, symbol: Z3_get_sort_name(context.context, sort))
    }

    /// Return a unique identifier for this sort
    public var id: UInt32 {
        return Z3_get_sort_id(context.context, sort)
    }

    /// Return the sort kind (e.g., array, tuple, int, bool, etc).
    ///
    /// - seealso: `Z3SortKind`
    public var sortKind: Z3SortKind {
        return Z3SortKind.fromZ3_sort_kind(Z3_get_sort_kind(context.context, sort))
    }

    init(context: Z3Context, sort: Z3_sort) {
        self.context = context
        self.sort = sort
    }
}

extension Z3Sort: Equatable {
    public static func == (lhs: Z3Sort, rhs: Z3Sort) -> Bool {
        return lhs.context.context == rhs.context.context
            && Z3_is_eq_sort(lhs.context.context, lhs.sort, rhs.sort)
    }
}

internal extension Sequence where Element == Z3Sort {
    func toZ3_sortPointerArray() -> [Z3_sort?] {
        return map { $0.sort }
    }
}

internal extension Sequence where Element == Z3_sort {
    func toZ3SortArray(context: Z3Context) -> [Z3Sort] {
        return map { Z3Sort(context: context, sort: $0) }
    }
}

internal extension Sequence where Element == Z3_func_decl? {
    func toZ3SortArray(context: Z3Context) -> [Z3Sort] {
        return map { Z3Sort(context: context, sort: $0!) }
    }
}
