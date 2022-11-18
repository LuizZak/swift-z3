import XCTest

@testable import SwiftZ3

class Z3CharTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Char = context.makeChar(1)

        XCTAssertEqual(sut.sort, context.charSort())
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3Char.getSort(context), context.charSort())
    }
}
