import XCTest

@testable import SwiftZ3

class Z3FloatTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Float = context.makeFloat(1)

        XCTAssertEqual(sut.sort, context.floatingPoint32Sort())
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3Float.getSort(context), context.floatingPoint32Sort())
    }
}
