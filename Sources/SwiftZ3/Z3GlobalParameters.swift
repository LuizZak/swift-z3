import CZ3

/// Contains static APIs for configuring global parameters for all Z3 contexts.
public enum Z3GlobalParameters {
    /// - Restore the value of all global (and module) parameters.
    /// This command will not affect already created objects (such as tactics and solvers).
    ///
    /// - seealso: `getParameter(id:)`
    /// - seealso: `setParameter(id:value:)`
    public static func resetAll() {
        Z3_global_param_reset_all()
    }

    /// Get a global (or module) parameter.
    ///
    /// Returns `nil` if the parameter value does not exist.
    ///
    /// - seealso: `resetAll()`
    /// - seealso: `setParameter(id:value:)`
    ///
    /// - remark: This function cannot be invoked simultaneously from different threads without synchronization.
    /// The result string stored in param_value is stored in shared location.
    public static func getParameter(id: String) -> String? {
        var str: Z3_string?

        if Z3_global_param_get(id, &str), let str = str {
            return str.toString()
        }

        return nil
    }
    
    /// Set a global (or module) parameter.
    /// This setting is shared by all Z3 contexts.
    ///
    /// When a Z3 module is initialized it will use the value of these parameters
    /// when Z3_params objects are not provided.
    ///
    /// The name of parameter can be composed of characters [a-z][A-Z], digits [0-9], '-' and '_'.
    /// The character '.' is a delimiter (more later).
    ///
    /// The parameter names are case-insensitive. The character '-' should be viewed as an "alias" for '_'.
    /// Thus, the following parameter names are considered equivalent: "pp.decimal-precision"  and "PP.DECIMAL_PRECISION".
    ///
    /// This function can be used to set parameters for a specific Z3 module.
    /// This can be done by using <module-name>.<parameter-name>.
    /// For example:
    /// `setParameter(id: "pp.decimal", "true")`
    /// will set the parameter "decimal" in the module "pp" to true.
    ///
    /// - seealso: `getParameter(id:)`
    /// - seealso: `resetAll()`
    public static func setParameter(id: String, value: String) {
        Z3_global_param_set(id, value)
    }
}
