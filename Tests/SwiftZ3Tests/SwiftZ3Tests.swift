import XCTest
import Z3
@testable import SwiftZ3

final class SwiftZ3Tests: XCTestCase {
    func testSimpleSolver() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let config = Z3Config()
        config.setParameter(name: "model", value: "true")

        let context = Z3Context(configuration: config)
        
        let roundMode = context.makeFpaRoundTowardZero()
        let left = context.makeConstant(name: "left", sort: FP32Sort.self)
        let width = context.makeConstant(name: "width", sort: FP32Sort.self)
        let right = context.makeConstant(name: "right", sort: FP32Sort.self)
        
        let lValue = context.makeEqual(left, context.makeFpaNumeralFloat(50.0, sort: FP32Sort.self))
        let wValue = context.makeEqual(width, context.makeFpaNumeralFloat(100.0, sort: FP32Sort.self))
        
        let rightEq = context.makeEqual(right, context.makeFpaAdd(roundMode, left, width))
        
        let solver = context.makeSolver()
        
        solver.assert([lValue, wValue, rightEq])
        XCTAssertEqual(solver.check(), Z3_L_TRUE)
        
        if let model = solver.getModel() {
            XCTAssertEqual(model.double(right), 150)
        } else {
            XCTFail("Failed to get expected model")
        }
    }

    static var allTests = [
        ("testSimpleSolver", testSimpleSolver),
    ]
}
