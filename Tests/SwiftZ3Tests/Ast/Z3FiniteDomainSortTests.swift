import XCTest

@testable import SwiftZ3

class Z3FiniteDomainSortTests: XCTestCase {
    func testCreateNumeral() {
        let context = Z3Context()
        let domain = context.makeStringSymbol("domain")
        let sut = context.makeFiniteDomainSort(name: domain, size: 64)

        let result = sut.createNumeral(32)

        XCTAssertEqual(result.astKind, .numeralAst)
    }
}
