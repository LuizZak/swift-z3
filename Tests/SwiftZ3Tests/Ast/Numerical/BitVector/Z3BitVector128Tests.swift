import XCTest

@testable import SwiftZ3

class Z3BitVector128Tests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut = context.makeInteger128Bv(highBits: 0x0, lowBits: 0x0)

        XCTAssertEqual(sut.sort, context.bitVectorSort(size: 128))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(
            Z3BitVector128.getSort(context),
            context.bitVectorSort(size: 128)
        )
    }
}
