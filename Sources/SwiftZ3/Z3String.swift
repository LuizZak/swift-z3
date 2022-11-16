import CZ3

public typealias Z3String = Z3_string

extension String {
    static func fromZ3String(_ string: Z3String) -> String {
        String(cString: string)
    }
}

extension Z3String {
    func toString() -> String {
        .fromZ3String(self)
    }
}
