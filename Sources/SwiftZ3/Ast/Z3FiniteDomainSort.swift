import CZ3

/// A named finite domain.
public class Z3FiniteDomainSort: Z3Sort {
    /// Gets the symbol for the name of this finite domain.
    public let name: Z3Symbol

    /// The size of this finite domain.
    public let size: UInt64

    init(context: Z3Context, sort: Z3_sort, name: Z3Symbol, size: UInt64) {
        self.name = name
        self.size = size

        super.init(context: context, sort: sort)
    }
}

public extension Z3FiniteDomainSort {
    /// Creates a new numeral belonging to this finite domain sort.
    ///
    /// - precondition: `value <= self.size`
    func createNumeral(_ value: UInt64) -> Z3FiniteDomainNumeral {
        let result = context.makeUnsignedInteger64Any(value, sort: self)

        return Z3FiniteDomainNumeral(context: context, ast: result.ast)
    }
}
