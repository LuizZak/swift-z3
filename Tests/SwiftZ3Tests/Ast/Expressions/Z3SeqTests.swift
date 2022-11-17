import XCTest

@testable import SwiftZ3

class Z3SeqTests: XCTestCase {
    func testSort() {
        let context = Z3Context()

        let sut: Z3Seq<IntSort> = context.makeSeqEmpty(SeqSort<IntSort>.self)

        XCTAssertEqual(sut.sort, context.seqSort(element: context.intSort()))
    }

    func testGetSort() {
        let context = Z3Context()

        XCTAssertEqual(Z3Seq<IntSort>.getSort(context), context.seqSort(element: context.intSort()))
    }

    func testCastTo() {
        let context = Z3Context()

        let seqAst = context.makeSeqEmpty(SeqSort<IntSort>.self)
        let typeErased = seqAst as AnyZ3Ast

        XCTAssertNotNil(typeErased.castToSequence(elementSort: IntSort.self))
        XCTAssertNil(typeErased.castTo(sort: IntSort.self))
    }
}
