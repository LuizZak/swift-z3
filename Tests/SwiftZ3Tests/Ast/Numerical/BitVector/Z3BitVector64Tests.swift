import XCTest

@testable import SwiftZ3

class Z3BitVector64Tests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut = context.makeInteger64Bv(1)

        XCTAssertEqual(sut.sort, context.bitVectorSort(size: 64))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3BitVector64.getSort(context), context.bitVectorSort(size: 64))
    }
}
