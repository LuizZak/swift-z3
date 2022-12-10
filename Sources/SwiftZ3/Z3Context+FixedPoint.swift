import CZ3

public extension Z3Context {
    // MARK: - Fixedpoint facilities

    /// Create a new fixedpoint context.
    func makeFixedPoint() -> Z3FixedPoint {
        Z3FixedPoint(
            context: self,
            fixedPoint: Z3_mk_fixedpoint(context)
        )
    }
}
