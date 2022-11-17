// TODO: Ideally `Z3Seq` would be a typealias of `Z3Ast` but because of limitations
// in extensions of nested generic types, we make it a subclass for now.

/// A AST class for Z3 sequence sorts with a given base element sort.
public class Z3Seq<Element: SortKind>: AnyZ3Ast {

}

public extension AnyZ3Ast {
    /// An unsafe cast from a generic `AnyZ3Ast` or a specialized `Z3Ast` to
    /// another specialized `Z3Seq` type.
    func unsafeCastToSequence<Element: SortKind>(elementSort: Element.Type = Element.self) -> Z3Seq<Element> {
        Z3Seq(context: context, ast: ast)
    }

    /// A runtime type-checked cast from a generic `AnyZ3Ast` or a specialized
    /// `Z3Seq` to another specialized `Z3Seq` type.
    ///
    /// The underlying `SortKind` of this AST type is checked, and if it matches
    /// the incoming sort, the result is a non-nil `Z3Seq` instance annotated with
    /// the requested type.
    func castToSequence<Element: SortKind>(elementSort: Element.Type = Element.self) -> Z3Seq<Element>? {
        if let currentSort = self.sort, SeqSort<Element>.isAssignableFrom(context, currentSort) {
            return Z3Seq(context: context, ast: ast)
        }

        return nil
    }
}

public extension Z3Seq {
    /// Gets the statically-typed Z3Sort associated with this `Z3Seq`.
    static func getSort(_ context: Z3Context) -> Z3Sort {
        context.seqSort(element: Element.getSort(context))
    }

    // MARK: - Functions and members

    /// Returns the AST for this sequence's length.
    var length: Z3Int {
        context.makeSeqLength(self)
    }

    /// Retrieve from this sequence the the element positioned at position `index`.
    subscript(index: Z3Int) -> Z3Ast<Element> {
        context.makeSeqNth(self, index: index)
    }

    /// Return index of the first occurrence of `search` in this sequence starting
    /// from `offset`.
    ///
    /// If this sequence does not contain `search`, then the value is -1, if `offset`
    /// is the length of this sequence, then the value is -1 as well.
    /// The value is -1 if `offset` is negative or larger than the length of
    /// this sequence.
    func index(of search: Z3Seq<Element>, offset: Z3Int) -> Z3Int {
        context.makeSeqIndex(self, substr: search, offset: offset)
    }

    /// Return index of the last occurrence of `search` in `sequence`.
    ///
    /// If `sequence` does not contain `search`, then the value is -1.
    func lastIndex(of search: Z3Seq<Element>) -> Z3Int {
        context.makeSeqLastIndex(self, substr: search)
    }
}


