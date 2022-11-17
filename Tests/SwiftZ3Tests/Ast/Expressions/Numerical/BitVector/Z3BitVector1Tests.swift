import XCTest

@testable import SwiftZ3

class Z3BitVector1Tests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut = context.makeInteger1Bv(1)

        XCTAssertEqual(sut.sort, context.bitVectorSort(size: 1))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3BitVector1.getSort(context), context.bitVectorSort(size: 1))
    }
}
