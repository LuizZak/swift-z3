import CZ3

public extension Z3Context {
    // MARK: - Regular Expressions

    /// Create a regular expression that accepts all singleton sequences of the
    /// regular expression sort
    func makeReAllChar<Element>(_ sort: ReSort<Element>.Type = ReSort<Element>.self) -> Z3RegularExp<Element> {
        Z3RegularExp(
            context: self,
            ast: Z3_mk_re_allchar(context, sort.getSort(self).sort)
        )
    }
}
