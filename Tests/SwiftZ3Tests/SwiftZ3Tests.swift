import XCTest
import Z3
@testable import SwiftZ3

final class SwiftZ3Tests: XCTestCase {
    func testFpaSolver() {
        let config = Z3Config()
        config.setParameter(name: "model", value: "true")

        let context = Z3Context(configuration: config)
        
        let roundMode = context.makeFpaRoundTowardZero()
        let left = context.makeConstant(name: "left", sort: Float.self)
        let width = context.makeConstant(name: "width", sort: Float.self)
        let right = context.makeConstant(name: "right", sort: Float.self)
        
        let lValue = context.makeEqual(left, context.makeFpaNumeralFloat(50.0, sort: Float.self))
        let wValue = context.makeEqual(width, context.makeFpaNumeralFloat(100.0, sort: Float.self))
        
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
    
    func testFpaSolverWithOperators() {
        let config = Z3Config()
        config.setParameter(name: "model", value: "true")

        let context = Z3Context(configuration: config)
        
        let left = context.makeConstant(name: "left", sort: Float.self)
        let width = context.makeConstant(name: "width", sort: Float.self)
        let right = context.makeConstant(name: "right", sort: Float.self)
        
        let lValue = left == context.makeFpaNumeral(50.0)
        let wValue = width == context.makeFpaNumeral(100.0)
        
        let rightEq = right == left + width
        
        let solver = context.makeSolver()
        
        solver.assert([lValue, wValue, rightEq])
        XCTAssertEqual(solver.check(), Z3_L_TRUE)
        
        if let model = solver.getModel() {
            XCTAssertEqual(model.double(right), 150)
        } else {
            XCTFail("Failed to get expected model")
        }
    }
    
    // TODO: Make this pass
    func xtestBitwiseExpr() {
        let config = Z3Config()
        config.setParameter(name: "model", value: "true")
        
        let context = Z3Context(configuration: config)
        
        let lhs = context.makeConstant(name: "lhs", sort: BitVectorSort32.self)
        let rhs = context.makeConstant(name: "rhs", sort: BitVectorSort32.self)
        let res = context.makeConstant(name: "res", sort: BitVectorSort32.self)
        
        let lhsValue = context.makeEqual(lhs, context.makeNumeral(number: "123", sort: BitVectorSort32.self))
        let rhsValue = context.makeEqual(rhs, context.makeNumeral(number: "3", sort: BitVectorSort32.self))
        
        let resValue = context.makeEqual(res, context.makeBvMul(lhs, rhs))
        
        let solver = context.makeSolver()
        
        solver.assert([lhsValue, rhsValue, resValue])
        XCTAssertEqual(solver.check(), Z3_L_TRUE)
        
        if let model = solver.getModel() {
            XCTAssertEqual(model.int(resValue), 150)
        } else {
            XCTFail("Failed to get expected model")
        }
    }

    static var allTests = [
        ("testFpaSolver", testFpaSolver),
        ("testFpaSolverWithOperators", testFpaSolverWithOperators)
    ]
}
