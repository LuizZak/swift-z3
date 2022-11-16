import XCTest

@testable import SwiftZ3

class Z3RealTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Real = context.makeReal(1)

        XCTAssertEqual(sut.sort, context.realSort())
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3Real.getSort(context), context.realSort())
    }
}
