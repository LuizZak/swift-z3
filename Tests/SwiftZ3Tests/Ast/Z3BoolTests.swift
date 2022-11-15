import XCTest

@testable import SwiftZ3

class Z3BoolTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Bool = context.makeTrue()

        XCTAssertEqual(sut.sort, context.boolSort())
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3Bool.getSort(context), context.boolSort())
    }
}
