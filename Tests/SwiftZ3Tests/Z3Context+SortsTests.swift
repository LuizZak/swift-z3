import XCTest

@testable import SwiftZ3

class Z3Context_SortsTests: XCTestCase {
    func testReSort() {
        let context = Z3Context()

        let seqSort = context.seqSort(element: context.intSort())
        let reSort = context.reSort(seqSort: seqSort)

        XCTAssertEqual(reSort.sortKind, .reSort)
    }

    func testIsReSort() {
        let context = Z3Context()

        let seqSort = context.seqSort(element: context.intSort())
        let reSort = context.reSort(seqSort: seqSort)

        XCTAssertTrue(context.isReSort(reSort))
    }

    func testGetReSortBasis() {
        let context = Z3Context()

        let seqSort = context.seqSort(element: context.intSort())
        let reSort = context.reSort(seqSort: seqSort)
        let basis = context.getReSortBasis(reSort)

        XCTAssertEqual(basis.sortKind, .seqSort)
        XCTAssertEqual(basis, seqSort)
    }
}
