import CZ3

/// Type constructor for a (recursive) datatype.
public class Z3Constructor {
    /// The context this `Z3Constructor` belongs
    public let context: Z3Context
    var constructor: Z3_constructor

    init(context: Z3Context, constructor: Z3_constructor) {
        self.context = context
        self.constructor = constructor
    }

    deinit {
        Z3_del_constructor(context.context, constructor)
    }
}

internal extension Sequence where Element == Z3Constructor {
    func toZ3_constructorPointerArray() -> [Z3_constructor?] {
        return map { $0.constructor }
    }
}
