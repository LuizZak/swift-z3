import CZ3

public extension Z3Context {
    // MARK: - Strings

    /// Create a string constant out of the string that is passed in
    /// The string may contain escape encoding for non-printable characters
    /// or characters outside of the basic printable ASCII range. For example, 
    /// the escape encoding `\\u{0}` represents the character 0 and the encoding
    /// `\\u{100}` represents the character 256.
    func makeString(_ value: String) -> Z3String {
        Z3String(
            context: self,
            ast: Z3_mk_string(context, value)
        )
    }

    /// Determine if `ast` is a string constant.
    func isString(_ ast: Z3AstBase) -> Bool {
        Z3_is_string(context, ast.ast)
    }

    /// Check if `s1` is lexicographically strictly less than `s2`.
    func makeStrLt(_ s1: Z3String, _ s2: Z3String) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_str_lt(context, s1.ast, s2.ast)
        )
    }

    /// Check if `s1` is equal or lexicographically strictly less than `s2`.
    func makeStrLe(_ s1: Z3String, _ s2: Z3String) -> Z3Bool {
        Z3Bool(
            context: self,
            ast: Z3_mk_str_le(context, s1.ast, s2.ast)
        )
    }

    /// Convert string to integer.
    func makeStrToInt(_ ast: Z3String) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_str_to_int(context, ast.ast)
        )
    }

    /// Integer to string conversion.
    func makeIntToStr(_ ast: Z3Int) -> Z3String {
        Z3String(
            context: self,
            ast: Z3_mk_int_to_str(context, ast.ast)
        )
    }

    /// String to code conversion.
    func makeStringToCode(_ ast: Z3String) -> Z3Int {
        Z3Int(
            context: self,
            ast: Z3_mk_string_to_code(context, ast.ast)
        )
    }

    /// Code to string conversion.
    func makeStringFromCode(_ ast: Z3Int) -> Z3String {
        Z3String(
            context: self,
            ast: Z3_mk_string_from_code(context, ast.ast)
        )
    }

    /// Unsigned bit-vector to string conversion.
    func makeUbvToStr<Sort>(_ ast: Z3BitVector<Sort>) -> Z3String {
        Z3String(
            context: self,
            ast: Z3_mk_ubv_to_str(context, ast.ast)
        )
    }

    /// Unsigned bit-vector to string conversion.
    func makeUbvToStr(_ ast: AnyZ3BitVector) -> Z3String {
        Z3String(
            context: self,
            ast: Z3_mk_ubv_to_str(context, ast.ast)
        )
    }

    /// ned bit-vector to string conversion.
    func makeSbvToStr<Sort>(_ ast: Z3BitVector<Sort>) -> Z3String {
        Z3String(
            context: self,
            ast: Z3_mk_sbv_to_str(context, ast.ast)
        )
    }

    /// ned bit-vector to string conversion.
    func makeSbvToStr(_ ast: AnyZ3BitVector) -> Z3String {
        Z3String(
            context: self,
            ast: Z3_mk_sbv_to_str(context, ast.ast)
        )
    }
}
