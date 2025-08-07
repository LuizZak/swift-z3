import CZ3

public extension Z3Context {
    // MARK: - Pseudo-Boolean

    /// Create a constraint asserting that at most `k` variables in `arguments` are true.
    ///
    /// This corresponds to the inequality:
    /// `args[0] + args[1] + ... + args[n] <= k`
    ///
    /// - Parameters:
    ///   - arguments: An array of `Z3Bool` representing the Boolean variables.
    ///   - k: The maximum number of variables allowed to be true.
    ///
    /// - seealso: `makeAtLeast`
    func makeAtMost(_ arguments: [Z3Bool], k: Int32) -> Z3Bool {
        preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_atmost(context, count, args, UInt32(k)))
        }
    }

    /// Create a constraint asserting that at least `k` variables in `arguments` are true.
    ///
    /// This corresponds to the inequality:
    /// `args[0] + args[1] + ... + args[n] >= k`
    ///
    /// - Parameters:
    ///   - arguments: An array of `Z3Bool` representing the Boolean variables.
    ///   - k: The minimum number of variables required to be true.
    ///
    /// - seealso: `makeAtMost`
    func makeAtLeast(_ arguments: [Z3Bool], k: Int32) -> Z3Bool {
        preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_atleast(context, count, args, UInt32(k)))
        }
    }

    /// Create a constraint asserting that a weighted sum of Boolean variables is less than or equal to `k`.
    ///
    /// This corresponds to the inequality:
    /// `coeffs[0]*args[0] + coeffs[1]*args[1] + ... + coeffs[n]*args[n] <= k`
    ///
    /// - Parameters:
    ///   - arguments: An array of `Z3Bool` representing the Boolean variables.
    ///   - coefficients: An array of coefficients corresponding to each variable.
    ///   - k: The maximum allowed value of the sum.
    ///
    /// - Precondition: The number of arguments must match the number of coefficients.
    ///
    /// - seealso: `makePbGe`
    /// - seealso: `makePbEq`
    func makePbLe(_ arguments: [Z3Bool], coefficients: [Int32], k: Int32) -> Z3Bool {
        precondition(arguments.count == coefficients.count)

        return preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_pble(context, count, args, coefficients, k))
        }
    }

    /// Create a constraint asserting that a weighted sum of Boolean variables is greater than or equal to `k`.
    ///
    /// This corresponds to the inequality:
    /// `coeffs[0]*args[0] + coeffs[1]*args[1] + ... + coeffs[n]*args[n] >= k`
    ///
    /// - Parameters:
    ///   - arguments: An array of `Z3Bool` representing the Boolean variables.
    ///   - coefficients: An array of coefficients corresponding to each variable.
    ///   - k: The minimum required value of the sum.
    ///
    /// - Precondition: The number of arguments must match the number of coefficients.
    ///
    /// - seealso: `makePbLe`
    /// - seealso: `makePbEq`
    func makePbGe(_ arguments: [Z3Bool], coefficients: [Int32], k: Int32) -> Z3Bool {
        precondition(arguments.count == coefficients.count)

        return preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_pbge(context, count, args, coefficients, k))
        }
    }

    /// Create a constraint asserting that a weighted sum of Boolean variables is equal to `k`.
    ///
    /// This corresponds to the equation:
    /// `coeffs[0]*args[0] + coeffs[1]*args[1] + ... + coeffs[n]*args[n] = k`
    ///
    /// - Parameters:
    ///   - arguments: An array of `Z3Bool` representing the Boolean variables.
    ///   - coefficients: An array of coefficients corresponding to each variable.
    ///   - k: The exact value the sum must match.
    ///
    /// - Precondition: The number of arguments must match the number of coefficients.
    ///
    /// - seealso: `makePbLe`
    /// - seealso: `makePbGe`
    func makePbEq(_ arguments: [Z3Bool], coefficients: [Int32], k: Int32) -> Z3Bool {
        precondition(arguments.count == coefficients.count)

        return preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_pbeq(context, count, args, coefficients, k))
        }
    }
}
