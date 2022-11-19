import XCTest

@testable import SwiftZ3

class Z3RegularExpTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3RegularExp<IntSort> = context.makeReAllChar(ReSort<IntSort>.self)

        XCTAssertEqual(
            sut.sort,
            context.reSort(seqSort: context.seqSort(element: context.intSort()))
        )
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(
            Z3RegularExp<IntSort>.getSort(context),
            context.reSort(seqSort: context.seqSort(element: context.intSort()))
        )
    }

    func testCastToRegularExp() {
        let context = Z3Context()

        let reAst = context.makeReAllChar(ReSort<IntSort>.self)
        let typeErased = reAst as AnyZ3Ast

        XCTAssertNotNil(typeErased.castToRegularExp(elementSort: IntSort.self))
        XCTAssertNil(typeErased.castTo(sort: IntSort.self))
    }
}
