import XCTest

@testable import SwiftZ3

class Z3BitVectorU64Tests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut = context.makeUnsignedInteger64Bv(1)

        XCTAssertEqual(sut.sort, context.bitVectorSort(size: 64))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3BitVectorU64.getSort(context), context.bitVectorSort(size: 64))
    }
}
