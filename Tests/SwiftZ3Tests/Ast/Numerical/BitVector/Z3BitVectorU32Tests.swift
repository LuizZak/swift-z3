import XCTest

@testable import SwiftZ3

class Z3BitVectorU32Tests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut = context.makeUnsignedIntegerBv(1)

        XCTAssertEqual(sut.sort, context.bitVectorSort(size: 32))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3BitVectorU32.getSort(context), context.bitVectorSort(size: 32))
    }
}
