import CZ3

public class Z3Sort {
    var sort: Z3_sort

    init(sort: Z3_sort) {
        self.sort = sort
    }
}

internal extension Sequence where Element == Z3Sort {
    func toZ3_sortPointerArray() -> [Z3_sort?] {
        return map { $0.sort }
    }
}

internal extension Sequence where Element == Z3_sort {
    func toZ3SortArray() -> [Z3Sort] {
        return map { Z3Sort(sort: $0) }
    }
}

internal extension Sequence where Element == Z3_func_decl? {
    func toZ3SortArray() -> [Z3Sort] {
        return map { Z3Sort(sort: $0!) }
    }
}
