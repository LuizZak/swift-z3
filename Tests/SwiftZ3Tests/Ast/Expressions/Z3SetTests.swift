import XCTest

@testable import SwiftZ3

class Z3SetTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Set<IntSort> = context.makeEmptySet(IntSort.self)

        XCTAssertEqual(sut.sort, context.makeSetSort(context.intSort()))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(
            Z3Set<IntSort>.getSort(context),
            context.makeSetSort(context.intSort())
        )
    }
}
