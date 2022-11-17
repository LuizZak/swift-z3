// TODO: Ideally `Z3RegularExp` would be a typealias of `Z3Ast` but because of limitations
// in extensions of nested generic types, we make it a subclass for now.

/// An AST class for Z3 regular expression sorts with a given base element sort.
public class Z3RegularExp<Element: SortKind>: AnyZ3Ast {

}

public extension AnyZ3Ast {
    /// An unsafe cast from a generic `AnyZ3Ast` or a specialized `Z3Ast` to
    /// another specialized `Z3RegularExp` type.
    func unsafeCastToRegularExp<Element: SortKind>(elementSort: Element.Type = Element.self) -> Z3RegularExp<Element> {
        Z3RegularExp(context: context, ast: ast)
    }

    /// A runtime type-checked cast from a generic `AnyZ3Ast` or a specialized
    /// `Z3RegularExp` to another specialized `Z3RegularExp` type.
    ///
    /// The underlying `SortKind` of this AST type is checked, and if it matches
    /// the incoming sort, the result is a non-nil `Z3RegularExp` instance
    /// annotated with the requested type.
    func castToRegularExp<Element: SortKind>(elementSort: Element.Type = Element.self) -> Z3RegularExp<Element>? {
        if let currentSort = self.sort, ReSort<Element>.isAssignableFrom(context, currentSort) {
            return Z3RegularExp(context: context, ast: ast)
        }

        return nil
    }
}

public extension Z3RegularExp {
    /// Gets the statically-typed Z3Sort associated with this `Z3RegularExp`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        context.reSort(seqSort: SeqSort<Element>.getSort(context))
    }
}
