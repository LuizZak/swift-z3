import CZ3

extension String {
    static func fromZ3String(_ string: Z3_string) -> String {
        String(cString: string)
    }
}

extension Z3_string {
    func toString() -> String {
        .fromZ3String(self)
    }
}
