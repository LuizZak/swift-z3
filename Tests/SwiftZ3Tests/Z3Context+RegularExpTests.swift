import XCTest

@testable import SwiftZ3

class Z3Context_RegularExpTests: XCTestCase {
    func testMakeReAllChar() {
        let sut = Z3Context()
        let reSort = sut.reSort(seqSort: sut.seqSort(element: sut.intSort()))

        let result = sut.makeReAllChar(ReSort<IntSort>.self)

        XCTAssertEqual(result.sort, reSort)
    }
}
