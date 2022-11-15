/// A sort that describes an array with a domain and range, specified by two
/// generic type arguments.
public struct ArraySort<Domain: SortKind, Range: SortKind>: SortKind {
    /// Returns the Array sort with the current type's Domain and Range.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        return context
            .makeArraySort(
                domain: Domain.getSort(context),
                range: Range.getSort(context)
            )
    }
}
