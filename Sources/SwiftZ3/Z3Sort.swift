import Z3

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
