/// A meta-sort that is used to represent regular expression sorts.
/// Is not a `SortKind` itself as it is not a concrete type that can specialize
/// `Z3Ast` instances, but used solely to refer to regular expression sorts.
///
/// The element is the element of the underlying sequence sort of the regular
/// expression.
public struct ReSort<Element: SortKind> {
    /// Creates a concrete instance of a Z3 sort that represents this sort kind.
    public static func getSort(_ context: Z3Context) -> Z3Sort {
        context.reSort(seqSort: SeqSort<Element>.getSort(context))
    }

    /// Returns whether this sort kind can be used to represent a more specialized
    /// typed `Z3Seq` instance with a given sort.
    ///
    /// Used for cross casts and downcasts of `Z3Seq<T>` and `AnyZ3Ast`.
    ///
    /// Always returns `true` if `sort` is the same as `self.getSort(context)`.
    static func isAssignableFrom(_ context: Z3Context, _ sort: Z3Sort) -> Bool {
        sort == context.reSort(seqSort: SeqSort<Element>.getSort(context))
    }
}
