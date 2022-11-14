import XCTest
import CZ3
@testable import SwiftZ3

class Z3AstTests: XCTestCase {
    func testCastTo() {
        let context = Z3Context()

        let floatAst = context.makeConstant(name: "floatAst", sort: Float.self)
        let typeErased = floatAst as AnyZ3Ast

        XCTAssertNotNil(typeErased.castTo(sort: Float.self))
        XCTAssertNil(typeErased.castTo(sort: IntSort.self))
        XCTAssertNil(typeErased.castTo(sort: Bool.self))
        XCTAssertNil(typeErased.castTo(sort: Double.self))
    }
}
