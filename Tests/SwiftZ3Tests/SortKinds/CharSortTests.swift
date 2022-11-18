import XCTest

@testable import SwiftZ3

class CharSortTests: XCTestCase {
    func testSortKind() {
        let context = Z3Context()

        let sort = CharSort.getSort(context)

        XCTAssertEqual(sort.sortKind, .charSort)
    }
}
