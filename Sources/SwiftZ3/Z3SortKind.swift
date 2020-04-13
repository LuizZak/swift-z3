import CZ3

/// The different kinds of Z3 types (See `Z3Context.getSortKind`).
public typealias Z3SortKind = Z3_sort_kind

public extension Z3SortKind {
    static let uninterpretedSort = Z3_UNINTERPRETED_SORT
    static let boolSort = Z3_BOOL_SORT
    static let intSort = Z3_INT_SORT
    static let realSort = Z3_REAL_SORT
    static let bvSort = Z3_BV_SORT
    static let arraySort = Z3_ARRAY_SORT
    static let datatypeSort = Z3_DATATYPE_SORT
    static let relationSort = Z3_RELATION_SORT
    static let finiteDomainSort = Z3_FINITE_DOMAIN_SORT
    static let floatingPointSort = Z3_FLOATING_POINT_SORT
    static let roundingModeSort = Z3_ROUNDING_MODE_SORT
    static let seqSort = Z3_SEQ_SORT
    static let reSort = Z3_RE_SORT
    static let unknownSort = Z3_UNKNOWN_SORT
}
