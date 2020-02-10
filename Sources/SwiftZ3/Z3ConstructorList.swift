import CZ3

public class Z3ConstructorList {
    /// The context this `Z3ConstructorList` belongs
    public let context: Z3Context
    var constructorList: Z3_constructor_list

    init(context: Z3Context, constructorList: Z3_constructor_list) {
        self.context = context
        self.constructorList = constructorList
    }

    deinit {
        Z3_del_constructor(context.context, constructorList)
    }
}

internal extension Sequence where Element == Z3ConstructorList {
    func toZ3_constructor_listPointerArray() -> [Z3_constructor_list?] {
        return map { $0.constructorList }
    }
}
