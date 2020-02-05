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
        
        let lValue = left == context.makeFloat(50.0)
        let wValue = width == context.makeFloat(100.0)
        
        let rightEq = right == left + width
        
        let solver = context.makeSolver()
        
        solver.assert([lValue, wValue, rightEq])
        XCTAssertEqual(solver.check(), .satisfiable)
        
        if let model = solver.getModel() {
            XCTAssertEqual(model.double(right), 150)
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

    // Derived from Z3's .NET sample code
    func testSudokuExample() {
        let ctx = Z3Context()

        // 9x9 matrix of integer variables
        var x: [[Z3Int]] = []
        for i in 0..<9 {
            x.append([])
            for j in 0..<9 {
                x[i].append(ctx.makeConstant(name: "x_\(i + 1)_\(j + 1)", sort: IntSort.self))
            }
        }

        // each cell contains a value in {1, ..., 9}
        var cells_c: [[Z3Bool]] = []
        for i in 0..<9 {
            cells_c.append([])
            for j in 0..<9 {
                cells_c[i].append(1 <= x[i][j] && x[i][j] <= 9)
            }
        }

        // each row contains a digit at most once
        var rows_c: [Z3Bool] = []
        for i in 0..<9 {
            rows_c.append(ctx.makeDistinct(x[i]))
        }

        // each column contains a digit at most once
        var cols_c: [Z3Bool] = []
        for j in 0..<9 {
            var column: [Z3Int] = []
            for i in 0..<9 {
                column.append(x[i][j])
            }

            cols_c.append(ctx.makeDistinct(column))
        }

        // each 3x3 square contains a digit at most once
        var sq_c: [[Z3Bool]] = []
        for i0 in 0..<3 {
            sq_c.append([])
            for j0 in 0..<3 {
                var square: [Z3Int] = []
                for i in 0..<3 {
                    for j in 0..<3 {
                        square.append(x[3 * i0 + i][3 * j0 + j])
                    }
                }

                sq_c[i0].append(ctx.makeDistinct(square))
            }
        }

        var sudoku_c = ctx.makeTrue()
        for t in cells_c {
            sudoku_c = sudoku_c && ctx.makeAnd(t)
        }
        sudoku_c = sudoku_c && ctx.makeAnd(rows_c)
        sudoku_c = sudoku_c && ctx.makeAnd(cols_c)
        for t in sq_c {
            sudoku_c = sudoku_c && ctx.makeAnd(t)
        }

        // sudoku instance, we use '0' for empty cells
        let instance: [[Int32]] = [
            [0, 0, 0, 0, 9, 4, 0, 3, 0],
            [0, 0, 0, 5, 1, 0, 0, 0, 7],
            [0, 8, 9, 0, 0, 0, 0, 4, 0],
            [0, 0, 0, 0, 0, 0, 2, 0, 8],
            [0, 6, 0, 2, 0, 1, 0, 5, 0],
            [1, 0, 2, 0, 0, 0, 0, 0, 0],
            [0, 7, 0, 0, 0, 0, 5, 2, 0],
            [9, 0, 0, 0, 6, 5, 0, 0, 0],
            [0, 4, 0, 9, 7, 0, 0, 0, 0]
        ]
        let expected: [[Int32]] = [
            [7, 1, 5, 8, 9, 4, 6, 3, 2],
            [2, 3, 4, 5, 1, 6, 8, 9, 7],
            [6, 8, 9, 7, 2, 3, 1, 4, 5],
            [4, 9, 3, 6, 5, 7, 2, 1, 8],
            [8, 6, 7, 2, 3, 1, 9, 5, 4],
            [1, 5, 2, 4, 8, 9, 7, 6, 3],
            [3, 7, 6, 1, 4, 8, 5, 2, 9],
            [9, 2, 8, 3, 6, 5, 4, 7, 1],
            [5, 4, 1, 9, 7, 2, 3, 8, 6]
        ]

        var instance_c = ctx.makeTrue()
        for i in 0..<9 {
            for j in 0..<9 {
                instance_c =
                    instance_c &&
                    ctx.makeIfThenElse(
                        instance[i][j] == ctx.makeInteger(value: 0),
                        ctx.makeTrue(),
                        x[i][j] == instance[i][j]
                    )
            }
        }

        let s = ctx.makeSolver()
        s.assert(sudoku_c)
        s.assert(instance_c)

        if s.check() == .satisfiable {
            let m = s.getModel()!
            var r: [[AnyZ3Ast]] = []
            for i in 0..<9 {
                r.append([])
                for j in 0..<9 {
                    r[i].append(m.eval(x[i][j], completion: false)!)
                }
            }

            var rInt = r.map { $0.map { $0.numeralInt } }

            XCTAssertEqual(rInt, expected)
        } else {
            XCTFail("Failed to solve sudoku")
        }
    }

    static var allTests = [
        ("testFpaSolver", testFpaSolver),
        ("testFpaSolverWithOperators", testFpaSolverWithOperators)
    ]
}
