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

    /// Create a regular expression language `self+`.
    func plus() -> Z3RegularExp {
        context.makeRePlus(self)
    }

    /// Create a regular expression language `self*`.
    func star() -> Z3RegularExp {
        context.makeReStar(self)
    }

    /// Create a regular expression language `[self]`.
    func option() -> Z3RegularExp {
        context.makeReOption(self)
    }

    /// Create the union of this regular language and every other in `others`.
    func union(_ others: [Z3RegularExp]) -> Z3RegularExp {
        context.makeReUnion([self] + others)
    }

    /// Create the concatenation of this regular language and every other in `others`.
    func concat(_ others: [Z3RegularExp]) -> Z3RegularExp {
        context.makeReConcat([self] + others)
    }

    /// Create the range regular expression over two sequences of length 1.
    func range(low: Z3Seq<Element>, high: Z3Seq<Element>) -> Z3RegularExp {
        context.makeReRange(low: low, high: high)
    }

    /// Create a regular expression loop.
    /// 
    /// The supplied regular expression `self` is repeated between `low` and `high`
    /// times. The `low` should be below `high` with one exception: when supplying
    /// the value `high` as 0, the meaning is to repeat the argument `self` at
    /// least `low` number of times, and with an unbounded upper bound.
    func loop(low: UInt32, high: UInt32) -> Z3RegularExp {
        context.makeReLoop(self, low: low, high: high)
    }

    /// Create a power regular expression.
    func power(count: UInt32) -> Z3RegularExp {
        context.makeRePower(self, count: count)
    }

    /// Create the intersection of the regular languages.
    func intersect(_ others: [Z3RegularExp]) -> Z3RegularExp {
        context.makeReIntersect([self] + others)
    }

    /// Create the complement of the regular language `self`.
    func complement() -> Z3RegularExp {
        context.makeReComplement(self)
    }

    /// Create the difference of this regular expression and `other`.
    func difference(_ other: Z3RegularExp) -> Z3RegularExp {
        context.makeReDiff(self, other)
    }
}
