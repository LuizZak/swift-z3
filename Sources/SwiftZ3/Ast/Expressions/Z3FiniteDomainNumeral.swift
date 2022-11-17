import CZ3

/// A numeral value belonging to a specific finite domain.
public class Z3FiniteDomainNumeral: AnyZ3Ast {
    /// Gets the `UInt64` value associated with this finite domain numeral value.
    public var uint64Value: UInt64 {
        context.getNumeralUInt64(self) ?? 0
    }
}
