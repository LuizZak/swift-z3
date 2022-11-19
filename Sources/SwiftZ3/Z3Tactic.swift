import CZ3

public class Z3Tactic {
    /// The context this `Z3Tactic` belongs
    public let context: Z3Context
    var tactic: Z3_tactic
    
    /// Return a string containing a description of parameters accepted by this
    /// tactic.
    public var help: String {
        return Z3_tactic_get_help(context.context, tactic).toString()
    }
    
    init(context: Z3Context, tactic: Z3_tactic) {
        self.context = context
        self.tactic = tactic
    }
    
    /// Return the parameter description set for this tactic object.
    public func getParamDescrs() -> Z3ParamDescrs {
        let descrs = Z3_tactic_get_param_descrs(context.context, tactic)

        return Z3ParamDescrs(context: context, descr: descrs!)
    }

    /// Return a tactic that applies `self` to a given goal and `next` to every
    /// subgoal produced by `self`.
    public func andThen(_ next: Z3Tactic) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_and_then(
                context.context,
                self.tactic,
                next.tactic
            )
        )
    }

    /// Return a tactic that first applies `self` to a given goal, if it fails
    /// then returns the result of `other` applied to the given goal.
    public func orElse(_ other: Z3Tactic) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_or_else(
                context.context,
                self.tactic,
                other.tactic
            )
        )
    }

    /// Return a tactic that applies `self` to a given goal and then `other`
    /// to every subgoal produced by `self`. The subgoals are processed in
    /// parallel.
    public func parallelAndThen(_ other: Z3Tactic) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_par_and_then(
                context.context,
                self.tactic,
                other.tactic
            )
        )
    }

    /// Return a tactic that applies `self` to a given goal for `milliseconds`.
    /// If `self` does not terminate in `milliseconds`, then it fails.
    public func tryFor(milliseconds: UInt32) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_try_for(
                context.context,
                self.tactic,
                milliseconds
            )
        )
    }

    /// Return a tactic that applies `self` to a given goal is the probe `probe`
    /// evaluates to true.
    /// If `probe` evaluates to false, then the new tactic behaves like the skip
    /// tactic.
    public func when(_ probe: Z3Probe) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_when(
                context.context,
                probe.probe,
                self.tactic
            )
        )
    }

    /// Return a tactic that applies `self` to a given goal if the probe `probe`
    /// evaluates to true, and `other` if `probe` evaluates to false.
    public func conditional(ifProbe probe: Z3Probe, else other: Z3Tactic) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_cond(
                context.context,
                probe.probe,
                self.tactic,
                other.tactic
            )
        )
    }

    /// Return a tactic that keeps applying `self` until the goal is not modified
    /// anymore or the maximum number of iterations `max` is reached.
    public func repeating(max: UInt32) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_repeat(
                context.context,
                self.tactic,
                max
            )
        )
    }

    /// Return a tactic that applies `self` using the given set of parameters.
    public func usingParams(_ params: Z3Params) -> Z3Tactic {
        Z3Tactic(
            context: context,
            tactic: Z3_tactic_using_params(
                context.context,
                self.tactic,
                params.params
            )
        )
    }

    /// Apply tactic `self` to `goal`, optionally using a set of parameters
    /// `params` if non-nil.
    public func apply(to goal: Z3Goal, params: Z3Params? = nil) -> Z3ApplyResult {
        if let params = params {
            return Z3ApplyResult(
                context: context,
                applyResult: Z3_tactic_apply_ex(
                    context.context,
                    tactic,
                    goal.goal,
                    params.params
                )
            )
        } else {
            return Z3ApplyResult(
                context: context,
                applyResult: Z3_tactic_apply(
                    context.context,
                    tactic,
                    goal.goal
                )
            )
        }
    }

    /// Return a tactic that applies the given tactics in parallel.
    ///
    /// - precondition: `tactics.count > 0`
    /// - precondition: All tactics belong to the same context.
    public static func parallelOr(_ tactics: [Z3Tactic]) -> Z3Tactic {
        precondition(!tactics.isEmpty)

        let context = tactics[0].context
        let tactics = tactics.toZ3_tacticPointerArray()

        return Z3Tactic(
            context: context,
            tactic: Z3_tactic_par_or(
                context.context,
                UInt32(tactics.count),
                tactics
            )
        )
    }
}

internal extension Sequence where Element: Z3Tactic {
    func toZ3_tacticPointerArray() -> [Z3_tactic?] {
        return map { $0.tactic }
    }
}
