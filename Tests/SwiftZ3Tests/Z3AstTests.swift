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

    func testCastTo_AnyFPSort() {
        let context = Z3Context()

        let floatAst = context.makeConstant(name: "floatAst", sort: Float.self)
        let nonFloatAst = context.makeConstant(name: "nonFloatAst", sort: IntSort.self)

        XCTAssertNotNil((floatAst as AnyZ3Ast).castTo(sort: AnyFPSort.self))
        XCTAssertNil((nonFloatAst as AnyZ3Ast).castTo(sort: AnyFPSort.self))
    }

    func testCastTo_AnyBitVectorSort() {
        let context = Z3Context()

        let bvAst = context.makeConstant(name: "bvAst", sort: BitVectorSort64.self)
        let nonBvAst = context.makeConstant(name: "nonBvAst", sort: IntSort.self)

        XCTAssertNotNil((bvAst as AnyZ3Ast).castTo(sort: AnyBitVectorSort.self))
        XCTAssertNil((nonBvAst as AnyZ3Ast).castTo(sort: AnyBitVectorSort.self))
    }
}
