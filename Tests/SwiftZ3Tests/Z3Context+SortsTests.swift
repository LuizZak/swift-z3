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

    func testStringSort() {
        let context = Z3Context()

        let sort = context.stringSort()

        XCTAssertEqual(sort.sortKind, .seqSort)
        XCTAssertEqual(sort, SeqSort<CharSort>.getSort(context))
    }

    func testIsStringSort() {
        let context = Z3Context()

        let sort = context.stringSort()

        XCTAssertTrue(context.isStringSort(sort))
    }

    func testCharSort() {
        let context = Z3Context()

        let sort = context.charSort()

        XCTAssertEqual(sort.sortKind, .charSort)
        XCTAssertEqual(sort, CharSort.getSort(context))
    }

    func testIsCharSort() {
        let context = Z3Context()

        let sort = context.charSort()

        XCTAssertTrue(context.isCharSort(sort))
    }
}
