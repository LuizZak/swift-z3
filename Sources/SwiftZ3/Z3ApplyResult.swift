import CZ3

/// Z3ApplyResult objects represent the result of an application of a tactic to
/// a goal. It contains the subgoals that were produced.
public class Z3ApplyResult {
    public let context: Z3Context
    let applyResult: Z3_apply_result

    /// Return the number of subgoals in this `Z3ApplyResult` object returned by
    /// `Z3Tactic.apply(to:params:)`.
    public var subgoalCount: UInt32 {
        Z3_apply_result_get_num_subgoals(context.context, applyResult)
    }

    internal init(context: Z3Context, applyResult: Z3_apply_result) {
        self.context = context
        self.applyResult = applyResult

        Z3_apply_result_inc_ref(context.context, applyResult)
    }

    deinit {
        Z3_apply_result_dec_ref(context.context, applyResult)
    }

    /// Converts this `Z3ApplyResult` object returned by `Z3Tactic.apply(to:params:)`
    /// into a string.
    public func toString() -> String {
        Z3_apply_result_to_string(context.context, applyResult).toString()
    }

    /// Return one of the subgoals in this `Z3ApplyResult` object returned by
    /// `Z3Tactic.apply(to:params:)`.
    ///
    /// - seealso: `subgoalCount`
    public func subgoalAt(index: UInt32) -> Z3Goal {
        precondition(index < subgoalCount)

        return Z3Goal(
            context: context,
            goal: Z3_apply_result_get_subgoal(
                context.context,
                applyResult,
                index
            )
        )
    }
}
