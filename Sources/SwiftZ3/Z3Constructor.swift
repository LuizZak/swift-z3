import Z3

public class Z3Constructor {
    var context: Z3Context
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
