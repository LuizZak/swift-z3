import XCTest

@testable import SwiftZ3

class Z3IntTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Int = context.makeInteger(1)

        XCTAssertEqual(sut.sort, context.intSort())
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3Int.getSort(context), context.intSort())
    }
}
