import XCTest

@testable import SwiftZ3

class Z3BitVector32Tests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut = context.makeIntegerBv(1)

        XCTAssertEqual(sut.sort, context.bitVectorSort(size: 32))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3BitVector32.getSort(context), context.bitVectorSort(size: 32))
    }
}
