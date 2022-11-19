import XCTest

@testable import SwiftZ3

class Z3AlgebraicTests: XCTestCase {
    func testCastToAlgebraic() {
        let context = Z3Context()

        let numAst = context.makeInteger(1)
        let typeErased = numAst as AnyZ3Ast

        XCTAssertNotNil(typeErased.castToAlgebraic())
    }

    func testCastToAlgebraic_nonAlgebraicExpression() {
        let context = Z3Context()

        let nonAlgebraicAst = context.makeTrue()
        let typeErased = nonAlgebraicAst as AnyZ3Ast

        XCTAssertNil(typeErased.castToAlgebraic())
    }
}
