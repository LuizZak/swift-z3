import CZ3

/// A configuration object for the Z3 context object.
///
/// Configurations are created in order to assign parameters prior to creating
/// contexts for Z3 interaction. For example, if the users wishes to use proof
/// generation, then call:
///
/// `Z3Config.setParameter("proof", "true")`
///
/// - remark: In previous versions of Z3, the `Z3_config` was used to store
/// global and module configurations. Now, we should use `Z3GlobalParameters.setParameter(id:value:)`.
///
/// The following parameters can be set:
///
/// - `proof`:  (Boolean)           Enable proof generation
/// - `debug_ref_count`: (Boolean)  Enable debug support for Z3_ast reference counting
/// - `trace`:  (Boolean)           Tracing support for VCC
/// - `trace_file_name`: (String)   Trace out file for VCC traces
/// - `timeout`: (unsigned)         default timeout (in milliseconds) used for solvers
/// - `well_sorted_check`:          type checker
/// - `auto_config`:                use heuristics to automatically select solver and configure it
/// - `model`:                      model generation for solvers, this parameter can be overwritten when creating a solver
/// - `model_validate`:             validate models produced by solvers
/// - `unsat_core`:                 unsat-core generation for solvers, this parameter can be overwritten when creating a solver
/// - `encoding`:                   the string encoding used internally (must be either "unicode" - 18 bit, "bmp" - 16 bit or "ascii" - 8 bit)
public class Z3Config {
    internal var config: Z3_config

    public init() {
        config = Z3_mk_config()
    }

    deinit {
        Z3_del_config(config)
    }

    public func setParameter(name: String, value: String) {
        Z3_set_param_value(config, name, value)
    }
}
