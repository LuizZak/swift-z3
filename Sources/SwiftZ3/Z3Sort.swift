import CZ3

public class Z3Sort {
    var context: Z3Context
    var sort: Z3_sort

    init(context: Z3Context, sort: Z3_sort) {
        self.context = context
        self.sort = sort
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
