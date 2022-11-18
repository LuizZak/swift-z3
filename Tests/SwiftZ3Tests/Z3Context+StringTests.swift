import XCTest

@testable import SwiftZ3

class Z3Context_StringTests: XCTestCase {
    func testMakeString() {
        let context = Z3Context()

        let ast = context.makeString("A string")

        XCTAssertEqual(ast.sort, context.stringSort())
        XCTAssertEqual(ast.sort?.sortKind, .seqSort)
    }

    func testMakeStringToCode() {
        let context = Z3Context()
        let str = context.makeString("A string")

        let ast = context.makeStringToCode(str)

        XCTAssertEqual(ast.sort, context.intSort())
    }
}
