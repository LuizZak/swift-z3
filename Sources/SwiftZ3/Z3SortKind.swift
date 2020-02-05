import CZ3

public enum Z3SortKind: UInt32 {
    case uninterpretedSort
    case boolSort
    case intSort
    case realSort
    case bvSort
    case arraySort
    case datatypeSort
    case relationSort
    case finiteDomainSort
    case floatingPointSort
    case roundingModeSort
    case seqSort
    case reSort
    case unknownSort = 1000
}

public extension Z3SortKind {
    var toZ3_sort_kind: Z3_sort_kind {
        return Z3_sort_kind(rawValue: rawValue)
    }

    static func fromZ3_sort_kind(_ value: Z3_sort_kind) -> Z3SortKind {
        return Z3SortKind(rawValue: value.rawValue) ?? .unknownSort
    }
}
