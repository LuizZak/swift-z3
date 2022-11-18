import CZ3

public typealias Z3CString = Z3_string

extension String {
    static func fromZ3CString(_ string: Z3CString) -> String {
        String(cString: string)
    }
}

extension Z3CString {
    func toString() -> String {
        .fromZ3CString(self)
    }
}
