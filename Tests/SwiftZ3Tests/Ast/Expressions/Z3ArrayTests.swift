import XCTest

@testable import SwiftZ3

class Z3ArrayTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Array<IntSort, RealSort> = context.makeConstArray(
            context.makeReal(0)
        )

        XCTAssertEqual(
            sut.sort,
            context.makeArraySort(domain: context.intSort(), range: context.realSort())
        )
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(
            Z3Array<IntSort, RealSort>.getSort(context),
            context.makeArraySort(domain: context.intSort(), range: context.realSort())
        )
    }
}
