import Z3

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
