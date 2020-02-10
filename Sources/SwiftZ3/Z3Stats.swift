import CZ3

public class Z3Stats {
    /// The context this `Z3Stats` belongs
    public let context: Z3Context
    var stats: Z3_stats

    /// Return the number of statistical data in this stats instance.
    public var size: UInt32 {
        return Z3_stats_size(context.context, stats)
    }

    init(context: Z3Context, stats: Z3_stats) {
        self.context = context
        self.stats = stats
    }

    /// Convert a statistics into a string.
    public func toString() -> String {
        return String(cString: Z3_stats_to_string(context.context, stats))
    }

    /// Return the key (a string) for a particular statistical data.
    ///
    /// - precondition: `index < size`
    public func getKey(_ index: UInt32) -> String {
        precondition(index < size)

        return String(cString: Z3_stats_get_key(context.context, stats, index))
    }

    /// Return `true` if the given statistical data is a unsigned integer.
    ///
    /// - precondition: `index < size`
    public func isUInt(_ index: UInt32) -> Bool {
        return Z3_stats_is_uint(context.context, stats, index)
    }

    /// Return `true` if the given statistical data is a double.
    ///
    /// - precondition: `index < size`
    public func isDouble(_ index: UInt32) -> Bool {
        return Z3_stats_is_double(context.context, stats, index)
    }

    /// Return the unsigned value of the given statistical data.
    ///
    /// - precondition: `index < size && isUInt(index)`
    public func getUIntValue(_ index: UInt32) -> UInt32 {
        return Z3_stats_get_uint_value(context.context, stats, index)
    }

    /// Return the double of the given statistical data.
    ///
    /// - precondition: `index < size && isDouble(index)`
    public func getDoubleValue(_ index: UInt32) -> Double {
        return Z3_stats_get_double_value(context.context, stats, index)
    }
}
