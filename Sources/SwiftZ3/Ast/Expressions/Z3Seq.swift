// TODO: Ideally `Z3Seq` would be a typealias of `Z3Ast` but because of limitations
// in extensions of nested generic types, we make it a subclass for now.

/// An AST class for Z3 sequence sorts with a given base element sort.
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

    /// Return index of the last occurrence of `search` in this sequence.
    ///
    /// If this sequence does not contain `search`, then the value is -1.
    func lastIndex(of search: Z3Seq<Element>) -> Z3Int {
        context.makeSeqLastIndex(self, substr: search)
    }

    /// Check if `subsequence` is a subsequence of this sequence.
    func contains(search: Z3Seq<Element>) -> Z3Bool {
        context.makeSeqContains(self, subsequence: search)
    }

    /// Extract a subsequence starting at `offset` of `length`.
    func extract(offset: Z3Int, length: Z3Int) -> Z3Seq {
        context.makeSeqExtract(self, offset: offset, length: length)
    }

    /// Replace the first occurrence of `src` with `dst` in this sequence.
    func replace(source: Z3Seq, dest: Z3Seq) -> Z3Seq {
        context.makeSeqReplace(self, src: source, dest: dest)
    }

    /// Retrieve from this sequence the unit sequence positioned at position
    /// `index`.
    func at(index: Z3Int) -> Z3Seq {
        context.makeSeqAt(self, index: index)
    }

    /// Create a regular expression that accepts this sequence.
    func toRegularExp() -> Z3RegularExp<Element> {
        context.makeSeqToRe(self)
    }

    /// Check for regular expression membership.
    func inRegExp(_ re: Z3RegularExp<Element>) -> Z3Bool {
        context.makeSeqInRe(self, regex: re)
    }

    /// Creates a map of the given function onto this sequence.
    func map<Result>(_ function: Z3FuncDecl) -> Z3Seq<Result> {
        context.makeSeqMap(self, function: function)
    }

    /// Creates a map of the given function onto this sequence starting at a given
    /// index.
    func map<Result>(_ function: Z3FuncDecl, startIndex: Z3Int) -> Z3Seq<Result> {
        context.makeSeqMapi(self, function: function, index: startIndex)
    }

    /// Creates a left fold of this sequence using a given function starting with
    /// a given accumulator.
    func foldLeft(_ function: Z3FuncDecl, accumulator: Z3Ast<Element>) -> Z3Ast<Element> {
        context.makeSeqFoldl(self, function: function, accumulator: accumulator)
    }

    /// Creates a left fold of this sequence using a given function starting with
    /// a given accumulator starting at a given index.
    func foldLeft(_ function: Z3FuncDecl, accumulator: Z3Ast<Element>, startIndex: Z3Int) -> Z3Ast<Element> {
        context.makeSeqFoldli(self, function: function, accumulator: accumulator, index: startIndex)
    }
}
