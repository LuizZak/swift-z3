import CZ3

public extension Z3Context {
    // MARK: - Sequences

    /// Create an empty sequence of the sequence of sort `sort`.
    func makeSeqEmpty<Element>(_ sort: SeqSort<Element>.Type = SeqSort<Element>.self) -> Z3Seq<Element> {
        Z3Seq(
            context: self,
            ast: Z3_mk_seq_empty(context, sort.getSort(self).sort)
        )
    }

    /// Create an empty sequence of the sequence of sort `sort`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sort` is a sequence sort.
    func makeSeqEmptyAny(_ sort: Z3Sort) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_empty(context, sort.sort)
        )
    }

    /// Create a unit sequence of `ast`.
    func makeSeqUnit<Element>(_ ast: Z3Ast<Element>) -> Z3Seq<Element> {
        Z3Seq(
            context: self,
            ast: Z3_mk_seq_unit(context, ast.ast)
        )
    }

    /// Create a unit sequence of `ast`.
    ///
    /// Type-erased version.
    func makeSeqUnitAny(_ ast: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_unit(context, ast.ast)
        )
    }

    /// Concatenate sequences.
    ///
    /// - precondition: The number of arguments must be greater than zero.
    func makeSeqConcat<Element>(_ args: [Z3Seq<Element>]) -> Z3Seq<Element> {
        precondition(!args.isEmpty)

        return preparingArgsAst(args) { (count, asts) in
            Z3Seq(
                context: self,
                ast: Z3_mk_seq_concat(context, count, asts)
            )
        }
    }

    /// Concatenate sequences.
    ///
    /// Type-erased version.
    ///
    /// - precondition: The number of arguments must be greater than zero.
    /// - precondition: All arguments are the same sequence sort.
    func makeSeqConcatAny(_ args: [AnyZ3Ast]) -> AnyZ3Ast {
        precondition(!args.isEmpty)

        return preparingArgsAst(args) { (count, asts) in
            AnyZ3Ast(
                context: self,
                ast: Z3_mk_seq_concat(context, count, asts)
            )
        }
    }

    /// Check if `prefix` is a prefix of `sequence`.
    func makeSeqPrefix<Element>(_ sequence: Z3Seq<Element>, prefix: Z3Seq<Element>) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_prefix(context, prefix.ast, sequence.ast)
        )
    }

    /// Check if `prefix` is a prefix of `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `prefix` and `sequence` are the same sequence sorts.
    func makeSeqPrefixAny(_ sequence: AnyZ3Ast, prefix: AnyZ3Ast) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_prefix(context, prefix.ast, sequence.ast)
        )
    }

    /// Check if `suffix` is a suffix of `sequence`.
    func makeSeqSuffix<Element>(_ sequence: Z3Seq<Element>, suffix: Z3Seq<Element>) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_suffix(context, suffix.ast, sequence.ast)
        )
    }

    /// Check if `suffix` is a suffix of `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `suffix` and `sequence` are the same sequence sorts.
    func makeSeqSuffixAny(_ sequence: AnyZ3Ast, suffix: AnyZ3Ast) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_suffix(context, suffix.ast, sequence.ast)
        )
    }

    /// Check if `subsequence` is a subsequence of `sequence`.
    func makeSeqContains<Element>(_ sequence: Z3Seq<Element>, subsequence: Z3Seq<Element>) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_contains(context, sequence.ast, subsequence.ast)
        )
    }

    /// Check if `subsequence` is a subsequence of `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `subsequence` and `sequence` are the same sequence sorts.
    func makeSeqContainsAny(_ sequence: AnyZ3Ast, subsequence: AnyZ3Ast) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_contains(context, sequence.ast, subsequence.ast)
        )
    }

    /// Extract subsequence starting at `offset` of `length`.
    func makeSeqExtract<Element>(_ sequence: Z3Seq<Element>, offset: Z3Int, length: Z3Int) -> Z3Seq<Element> {
        Z3Seq(
            context: self,
            ast: Z3_mk_seq_extract(context, sequence.ast, offset.ast, length.ast)
        )
    }

    /// Extract subsequence starting at `offset` of `length`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, `offset` and `length` are
    /// int sort.
    func makeSeqExtractAny(_ sequence: AnyZ3Ast, offset: AnyZ3Ast, length: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_extract(context, sequence.ast, offset.ast, length.ast)
        )
    }

    /// Replace the first occurrence of `src` with `dst` in `sequence`.
    func makeSeqReplace<Element>(_ sequence: Z3Seq<Element>, src: Z3Seq<Element>, dest: Z3Seq<Element>) -> Z3Seq<Element> {
        Z3Seq(
            context: self,
            ast: Z3_mk_seq_extract(context, sequence.ast, src.ast, dest.ast)
        )
    }

    /// Replace the first occurrence of `src` with `dst` in `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence`, `src`, and `dest` are the same sequence sort.
    func makeSeqReplaceAny(_ sequence: AnyZ3Ast, src: AnyZ3Ast, dest: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_extract(context, sequence.ast, src.ast, dest.ast)
        )
    }

    /// Retrieve from `sequence` the unit sequence positioned at position `index`.
    func makeSeqAt<Element>(_ sequence: Z3Seq<Element>, index: Z3Int) -> Z3Seq<Element> {
        Z3Seq(
            context: self,
            ast: Z3_mk_seq_at(context, sequence.ast, index.ast)
        )
    }

    /// Retrieve from `sequence` the unit sequence positioned at position `index`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, `index` is int sort.
    func makeSeqAtAny(_ sequence: AnyZ3Ast, index: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_at(context, sequence.ast, index.ast)
        )
    }

    /// Retrieve from `sequence` the the element positioned at position `index`.
    func makeSeqNth<Element>(_ sequence: Z3Seq<Element>, index: Z3Int) -> Z3Ast<Element> {
        Z3Ast(
            context: self,
            ast: Z3_mk_seq_nth(context, sequence.ast, index.ast)
        )
    }

    /// Retrieve from `sequence` the the element positioned at position `index`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, `index` is int sort.
    func makeSeqNthAny(_ sequence: AnyZ3Ast, index: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_nth(context, sequence.ast, index.ast)
        )
    }

    /// Returns the length of `sequence`.
    func makeSeqLength<Element>(_ sequence: Z3Seq<Element>) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_seq_length(context, sequence.ast)
        )
    }

    /// Returns the length of `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence`, is a sequence sort.
    func makeSeqLengthAny(_ sequence: AnyZ3Ast) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_seq_length(context, sequence.ast)
        )
    }

    /// Return index of the first occurrence of `substr` in `sequence` starting
    /// from `offset`.
    ///
    /// If `sequence` does not contain `substr`, then the value is -1, if `offset`
    /// is the length of `sequence`, then the value is -1 as well.
    /// The value is -1 if `offset` is negative or larger than the length of
    /// `sequence`.
    func makeSeqIndex<Element>(_ sequence: Z3Seq<Element>, substr: Z3Seq<Element>, offset: Z3Int) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_seq_index(context, sequence.ast, substr.ast, offset.ast)
        )
    }

    /// Return index of the first occurrence of `substr` in `sequence` starting
    /// from `offset`.
    ///
    /// If `sequence` does not contain `substr`, then the value is -1, if `offset`
    /// is the length of `sequence`, then the value is -1 as well.
    /// The value is -1 if `offset` is negative or larger than the length of
    /// `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` and `substr` are the same sequence sort, `offset`
    /// is int sort.
    func makeSeqIndexAny(_ sequence: AnyZ3Ast, substr: AnyZ3Ast, offset: AnyZ3Ast) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_seq_index(context, sequence.ast, substr.ast, offset.ast)
        )
    }

    /// Return index of the last occurrence of `substr` in `sequence`.
    ///
    /// If `sequence` does not contain `substr`, then the value is -1.
    func makeSeqLastIndex<Element>(_ sequence: Z3Seq<Element>, substr: Z3Seq<Element>) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_seq_last_index(context, sequence.ast, substr.ast)
        )
    }

    /// Return index of the last occurrence of `substr` in `sequence`.
    ///
    /// If `sequence` does not contain `substr`, then the value is -1.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` and `substr` are the same sequence sort.
    func makeSeqLastIndexAny(_ sequence: AnyZ3Ast, substr: AnyZ3Ast) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_seq_last_index(context, sequence.ast, substr.ast)
        )
    }

    /// Create a regular expression that accepts the sequence `sequence`.
    func makeSeqToRe<Element>(_ sequence: Z3Seq<Element>) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_seq_to_re(context, sequence.ast)
        )
    }

    /// Create a regular expression that accepts the sequence `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort.
    func makeSeqToReAny(_ sequence: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_to_re(context, sequence.ast)
        )
    }

    /// Check for regular expression membership.
    func makeSeqInRe<Element>(_ sequence: Z3Seq<Element>, regex: Z3RegularExp<Element>) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_in_re(context, sequence.ast, regex.ast)
        )
    }

    /// Check for regular expression membership.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, and `regex` is a regular
    /// expression sort with the same basis sort as `sequence`.
    func makeSeqInReAny(_ sequence: AnyZ3Ast, regex: AnyZ3Ast) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_seq_in_re(context, sequence.ast, regex.ast)
        )
    }

    /// Create a map of the function `function` over the sequence `sequence`.
    func makeSeqMap<Element, Result>(_ sequence: Z3Seq<Element>, function: Z3FuncDecl) -> Z3Seq<Result> {
        Z3Seq(
            context: self,
            ast: Z3_mk_seq_map(context, function.ast, sequence.ast)
        )
    }

    /// Create a map of the function `function` over the sequence `sequence`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, and `function` is a function
    /// sort.
    func makeSeqMapAny(_ sequence: AnyZ3Ast, function: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_map(context, function.ast, sequence.ast)
        )
    }

    /// Create a map of the function `function` over the sequence `sequence`
    /// starting at index `i`.
    func makeSeqMapi<Element, Result>(_ sequence: Z3Seq<Element>, function: Z3FuncDecl, index: Z3Int) -> Z3Seq<Result> {
        Z3Seq(
            context: self,
            ast: Z3_mk_seq_mapi(context, function.ast, index.ast, sequence.ast)
        )
    }

    /// Create a map of the function `function` over the sequence `sequence`
    /// starting at index `i`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, `function` is a function
    /// sort, and `index` is an int sort.
    func makeSeqMapiAny(_ sequence: AnyZ3Ast, function: AnyZ3Ast, index: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_mapi(context, function.ast, index.ast, sequence.ast)
        )
    }

    /// Create a fold of the function `function` over the sequence `sequence`
    /// with accumulator `accumulator`.
    func makeSeqFoldl<Element>(_ sequence: Z3Seq<Element>, function: Z3FuncDecl, accumulator: Z3Ast<Element>) -> Z3Ast<Element> {
        Z3Ast(
            context: self,
            ast: Z3_mk_seq_foldl(context, sequence.ast, function.ast, accumulator.ast)
        )
    }

    /// Create a fold of the function `function` over the sequence `sequence`
    /// with accumulator `accumulator`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, `function` is a function
    /// sort, and `accumulator` is the same sort as the elements of `sequence`.
    func makeSeqFoldlAny(_ sequence: AnyZ3Ast, function: AnyZ3Ast, accumulator: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_foldl(context, sequence.ast, function.ast, accumulator.ast)
        )
    }

    /// Create a fold with index tracking of the function `function` over the
    /// sequence `sequence` with accumulator `accumulator` starting at index `index`.
    func makeSeqFoldli<Element>(_ sequence: Z3Seq<Element>, function: Z3FuncDecl, accumulator: Z3Ast<Element>, index: Z3Int) -> Z3Ast<Element> {
        Z3Ast(
            context: self,
            ast: Z3_mk_seq_foldli(context, sequence.ast, function.ast, accumulator.ast, index.ast)
        )
    }

    /// Create a fold with index tracking of the function `function` over the
    /// sequence `sequence` with accumulator `accumulator` starting at index `index`.
    ///
    /// Type-erased version.
    ///
    /// - precondition: `sequence` is a sequence sort, `function` is a function
    /// sort, `accumulator` is the same sort as the elements of `sequence`, and
    /// `index` is an int sort.
    func makeSeqFoldliAny(_ sequence: AnyZ3Ast, function: AnyZ3Ast, accumulator: AnyZ3Ast, index: AnyZ3Ast) -> AnyZ3Ast {
        AnyZ3Ast(
            context: self,
            ast: Z3_mk_seq_foldli(context, sequence.ast, function.ast, accumulator.ast, index.ast)
        )
    }
}
