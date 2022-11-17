import XCTest

@testable import SwiftZ3

class Z3DoubleTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Double = context.makeFloat(1)

        XCTAssertEqual(sut.sort, context.floatingPoint64Sort())
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3Double.getSort(context), context.floatingPoint64Sort())
    }
}
