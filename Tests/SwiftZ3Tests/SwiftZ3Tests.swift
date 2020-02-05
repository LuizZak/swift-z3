import XCTest
import CZ3
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
        XCTAssertEqual(solver.check(), .satisfiable)
        
        if solver.getModel() != nil {
            XCTAssertEqual(right.numeralDouble, 150)
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
        
        let lValue = left == context.makeFloat(50.0)
        let wValue = width == context.makeFloat(100.0)
        
        let rightEq = right == left + width
        
        let solver = context.makeSolver()
        
        solver.assert([lValue, wValue, rightEq])
        XCTAssertEqual(solver.check(), .satisfiable)
        
        if solver.getModel() != nil {
            XCTAssertEqual(right.numeralDouble, 150)
        } else {
            XCTFail("Failed to get expected model")
        }
    }
    
    func testBitwiseExpr() {
        let config = Z3Config()
        config.setParameter(name: "model", value: "true")
        
        let context = Z3Context(configuration: config)
        
        let lhs = context.makeConstant(name: "lhs", sort: BitVectorSort32.self)
        let rhs = context.makeConstant(name: "rhs", sort: BitVectorSort32.self)
        let res = context.makeConstant(name: "res", sort: BitVectorSort32.self)

        let lhsValue = context.makeEqual(lhs, context.makeIntegerBv(value: 123))
        let rhsValue = context.makeEqual(rhs, context.makeIntegerBv(value: 3))
        
        let resValue = context.makeEqual(res, context.makeBvMul(lhs, rhs))
        let resValueInt = context.makeBv2Int(res, isSigned: true)
        
        let solver = context.makeSolver()
        
        solver.assert([lhsValue, rhsValue, resValue])
        XCTAssertEqual(solver.check(), .satisfiable)
        
        if let model = solver.getModel() {
            XCTAssertEqual(model.int(resValueInt), 369)
        } else {
            XCTFail("Failed to get expected model")
        }
    }
    
    // Derived from Z3's .NET sample code
    func testFloatingPointExample2() {
        let ctx = Z3Context()
        
        let doubleSort = ctx.floatingPoint64Sort()
        let rmSort = ctx.makeFpaRoundingModeSort()

        let rm = ctx.makeConstant(name: "rm", sort: rmSort)
        let x = ctx.makeConstant(name: "x", sort: ctx.bitVectorSort(size: 64))
        
        let y = ctx.makeConstant(name: "y", sort: doubleSort)
        let fpVal = ctx.makeFpaNumeralInt(42, sort: doubleSort)

        let c1 = ctx.makeEqualAny(y, fpVal)
        let c2 = ctx.makeEqualAny(x, ctx.makeFpaToBvAny(rm, y, 64, signed: false))
        let c3 = ctx.makeEqualAny(x, ctx.makeBitVectorAny(42, bitWidth: 64))
        let c4 = ctx.makeEqualAny(ctx.makeNumeral(number: "42", sort: ctx.realSort()), ctx.makeFpaToReal(fpVal.castTo(type: AnyFPSort.self)))
        let c5 = ctx.makeAnd([c1, c2, c3, c4])

        /* Generic solver */
        let s = ctx.makeSolver()
        s.assert(c5)

        XCTAssertEqual(
            s.toString(), """
            (declare-fun x () (_ BitVec 64))
            (declare-fun y () (_ FloatingPoint 11 53))
            (declare-fun rm () RoundingMode)
            (assert (and (= y (fp #b0 #b10000000100 #x5000000000000))
                 (= x ((_ fp.to_ubv 64) rm y))
                 (= x #x000000000000002a)
                 (= 42.0 (fp.to_real (fp #b0 #b10000000100 #x5000000000000)))))

            """)

        if s.check() == .satisfiable {
            XCTAssertEqual(
                s.getModel()?.toString(), """
                y -> (fp #b0 #b10000000100 #x5000000000000)
                rm -> roundNearestTiesToEven
                x -> #x000000000000002a

                """)
        } else {
            XCTFail("Failed to get expected model")
        }
    }
    
    // Derived from Z3's .NET sample code
    func testFloatingPointExample2_withTypeSystem() {
        let ctx = Z3Context()
        
        let rm = ctx.makeConstant(name: "rm", sort: RoundingMode.self)
        let x = ctx.makeConstant(name: "x", sort: BitVectorSort64.self)
        
        let y = ctx.makeConstant(name: "y", sort: Double.self)
        let fpVal = ctx.makeFpaNumeralInt(42, sort: Double.self)

        let c1 = ctx.makeEqual(y, fpVal)
        let c2 = ctx.makeEqual(x, ctx.makeFpaToBv(rm, y, BitVectorSort64.self, signed: false))
        let c3 = ctx.makeEqual(x, ctx.makeBitVector(42))
        let c4 = ctx.makeEqual(ctx.makeNumeral(number: "42", sort: RealSort.self), ctx.makeFpaToReal(fpVal))
        let c5 = ctx.makeAnd([c1, c2, c3, c4])

        /* Generic solver */
        let s = ctx.makeSolver()
        s.assert(c5)

        XCTAssertEqual(
            s.toString(), """
            (declare-fun x () (_ BitVec 64))
            (declare-fun y () (_ FloatingPoint 11 53))
            (declare-fun rm () RoundingMode)
            (assert (and (= y (fp #b0 #b10000000100 #x5000000000000))
                 (= x ((_ fp.to_ubv 64) rm y))
                 (= x #x000000000000002a)
                 (= 42.0 (fp.to_real (fp #b0 #b10000000100 #x5000000000000)))))

            """)

        if s.check() == .satisfiable {
            XCTAssertEqual(
                s.getModel()?.toString(), """
                y -> (fp #b0 #b10000000100 #x5000000000000)
                rm -> roundNearestTiesToEven
                x -> #x000000000000002a

                """)
        } else {
            XCTFail("Failed to get expected model")
        }
    }

    static var allTests = [
        ("testFpaSolver", testFpaSolver),
        ("testFpaSolverWithOperators", testFpaSolverWithOperators)
    ]
}
