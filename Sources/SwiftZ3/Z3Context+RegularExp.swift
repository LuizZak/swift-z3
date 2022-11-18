import CZ3

public extension Z3Context {
    // MARK: - Regular Expressions

    /// Create the regular language `re+`.
    func makeRePlus<Element>(_ re: Z3RegularExp<Element>) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_plus(context, re.ast)
        )
    }

    /// Create the regular language `re+`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `re` is of a regular expression sort.
    func makeRePlusAny(_ re: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_plus(context, re.ast)
        )
    }

    /// Create the regular language `re*`.
    func makeReStar<Element>(_ re: Z3RegularExp<Element>) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_star(context, re.ast)
        )
    }

    /// Create the regular language `re*`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `re` is of a regular expression sort.
    func makeReStarAny(_ re: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_star(context, re.ast)
        )
    }

    /// Create the regular language `[re]`.
    func makeReOption<Element>(_ re: Z3RegularExp<Element>) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_option(context, re.ast)
        )
    }

    /// Create the regular language `[re]`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `re` is of a regular expression sort.
    func makeReOptionAny(_ re: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_option(context, re.ast)
        )
    }

    /// Create the union of the regular languages.
    ///
    /// - precondition: `asts.count > 0`.
    func makeReUnion<Element>(_ asts: [Z3RegularExp<Element>]) -> Z3RegularExp<Element> {
        precondition(!asts.isEmpty)

        return preparingArgsAst(asts) { (count, asts) in
            Z3RegularExp(
                context: self,
                ast: Z3_mk_re_union(context, count, asts)
            )
        }
    }

    /// Create the union of the regular languages.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `asts.count > 0`.
    /// - precondition: `asts` are the same regular expression sort.
    func makeReUnionAny(_ asts: [AnyZ3Ast]) -> AnyZ3Ast {
        precondition(!asts.isEmpty)

        return preparingArgsAst(asts) { (count, asts) in
            AnyZ3Ast(
                context: self,
                ast: Z3_mk_re_union(context, count, asts)
            )
        }
    }

    /// Create the concatenation of the regular languages.
    ///
    /// - precondition: `asts.count > 0`.
    func makeReConcat<Element>(_ asts: [Z3RegularExp<Element>]) -> Z3RegularExp<Element> {
        precondition(!asts.isEmpty)

        return preparingArgsAst(asts) { (count, asts) in
            Z3RegularExp(
                context: self,
                ast: Z3_mk_re_concat(context, count, asts)
            )
        }
    }

    /// Create the concatenation of the regular languages.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `asts.count > 0`.
    /// - precondition: `asts` are the same regular expression sort.
    func makeReConcatAny(_ asts: [AnyZ3Ast]) -> AnyZ3Ast {
        precondition(!asts.isEmpty)

        return preparingArgsAst(asts) { (count, asts) in
            AnyZ3Ast(
                context: self,
                ast: Z3_mk_re_concat(context, count, asts)
            )
        }
    }

    /// Create the range regular expression over two sequences of length 1.
    func makeReRange<Element>(
        low: Z3RegularExp<Element>,
        high: Z3RegularExp<Element>
    ) -> Z3RegularExp<Element> {

        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_range(context, low.ast, high.ast)
        )
    }

    /// Create the range regular expression over two sequences of length 1.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `low` and `high` are the same regular expression sort.
    func makeReRangeAny(low: AnyZ3Ast, high: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_range(context, low.ast, high.ast)
        )
    }

    /// Create a regular expression that accepts all singleton sequences of the
    /// regular expression sort.
    func makeReAllChar<Element>(
        _ sort: ReSort<Element>.Type = ReSort<Element>.self
    ) -> Z3RegularExp<Element> {

        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_allchar(context, sort.getSort(self).sort)
        )
    }

    /// Create a regular expression that accepts all singleton sequences of the
    /// regular expression sort.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sort` is a regular expression sort.
    func makeReAllCharAny(_ sort: Z3Sort) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_allchar(context, sort.sort)
        )
    }

    /// Create a regular expression loop.
    /// 
    /// The supplied regular expression `ast` is repeated between `low` and `high`
    /// times. The `low` should be below `high` with one exception: when supplying
    /// the value `high` as 0, the meaning is to repeat the argument `ast` at least
    /// `low` number of times, and with an unbounded upper bound.
    func makeReLoop<Element>(
        _ ast: Z3RegularExp<Element>,
        low: UInt32,
        high: UInt32
    ) -> Z3RegularExp<Element> {

        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_loop(context, ast.ast, low, high)
        )
    }

    /// Create a regular expression loop.
    /// 
    /// The supplied regular expression `ast` is repeated between `low` and `high`
    /// times. The `low` should be below `high` with one exception: when supplying
    /// the value `high` as 0, the meaning is to repeat the argument `ast` at least
    /// `low` number of times, and with an unbounded upper bound.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `ast` is of a regular expression sort.
    func makeReLoopAny(_ ast: AnyZ3Ast, low: UInt32, high: UInt32) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_loop(context, ast.ast, low, high)
        )
    }

    /// Create a power regular expression.
    func makeRePower<Element>(_ ast: Z3RegularExp<Element>, count: UInt32) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_power(context, ast.ast, count)
        )
    }

    /// Create a power regular expression.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `ast` is of a regular expression sort.
    func makeRePowerAny(_ ast: AnyZ3Ast, count: UInt32) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_power(context, ast.ast, count)
        )
    }

    /// Create the intersection of the regular languages.
    ///
    /// - precondition: `asts.count > 0`.
    func makeReIntersect<Element>(_ asts: [Z3RegularExp<Element>]) -> Z3RegularExp<Element> {
        precondition(!asts.isEmpty)

        return preparingArgsAst(asts) { (count, asts) in
            Z3RegularExp(
                context: self,
                ast: Z3_mk_re_intersect(context, count, asts)
            )
        }
    }

    /// Create the intersection of the regular languages.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `asts.count > 0`.
    /// - precondition: `asts` are the same regular expression sort.
    func makeReIntersectAny(_ asts: [AnyZ3Ast]) -> AnyZ3Ast {
        precondition(!asts.isEmpty)

        return preparingArgsAst(asts) { (count, asts) in
            AnyZ3Ast(
                context: self,
                ast: Z3_mk_re_intersect(context, count, asts)
            )
        }
    }

    /// Create the complement of the regular language `re`.
    func makeReComplement<Element>(_ re: Z3RegularExp<Element>) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_complement(context, re.ast)
        )
    }

    /// Create the complement of the regular language `re`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `re` is of a regular expression sort.
    func makeReComplementAny(_ re: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_complement(context, re.ast)
        )
    }

    /// Create the difference of regular expressions.
    func makeReDiff<Element>(_ re1: Z3RegularExp<Element>, _ re2: Z3RegularExp<Element>) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_diff(context, re1.ast, re2.ast)
        )
    }

    /// Create the difference of regular expressions.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `re1` and `re2` are the same regular expression sort.
    func makeReDiffAny(_ re1: AnyZ3Ast, _ re2: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_diff(context, re1.ast, re2.ast)
        )
    }

    /// Create an empty regular expression of sort `sort`.
    func makeReEmpty<Element>(
        _ sort: ReSort<Element>.Type = ReSort<Element>.self
    ) -> Z3RegularExp<Element> {

        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_empty(context, sort.getSort(self).sort)
        )
    }

    /// Create an empty regular expression of sort `sort`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sort` is of a regular expression sort.
    func makeReEmptyAny(_ sort: Z3Sort) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_empty(context, sort.sort)
        )
    }

    /// Create an universal regular expression of sort `sort`.
    func makeReFull<Element>(
        _ sort: ReSort<Element>.Type = ReSort<Element>.self
    ) -> Z3RegularExp<Element> {

        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_full(context, sort.getSort(self).sort)
        )
    }

    /// Create an universal regular expression of sort `sort`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sort` is of a regular expression sort.
    func makeReFullAny(_ sort: Z3Sort) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_re_full(context, sort.sort)
        )
    }

    /// Creates a character literal.
    func makeChar(_ character: UInt32) -> Z3Char {
        Z3Char(
            context: self,
            ast: Z3_mk_char(context, character)
        )
    }

    /// Create less than or equal to between two characters.
    func makeCharLe(_ ch1: Z3Char, _ ch2: Z3Char) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_char_le(context, ch1.ast, ch2.ast)
        )
    }

    /// Create an integer (code point) from character.
    func makeCharToInt(_ char: Z3Char) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_char_to_int(context, char.ast)
        )
    }

    /// Create a bit-vector (code point) from character.
    func makeCharToBv(_ char: Z3Char) -> AnyZ3BitVector {
        AnyZ3BitVector(
            context: self,
            ast: Z3_mk_char_to_bv(context, char.ast)
        )
    }

    /// Create a character from a bit-vector (code point).
    func makeCharFromBv<Sort: BitVectorSort>(_ bv: Z3BitVector<Sort>) -> Z3Char {
        Z3Char(
            context: self,
            ast: Z3_mk_char_from_bv(context, bv.ast)
        )
    }

    /// Create a check if the character is a digit.
    func makeCharIsDigit(_ char: Z3Char) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_char_is_digit(context, char.ast)
        )
    }
}
