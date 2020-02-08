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

        let lhsValue = context.makeEqual(lhs, context.makeIntegerBv(123))
        let rhsValue = context.makeEqual(rhs, context.makeIntegerBv(3))
        
        let resValue = context.makeEqual(res, context.makeBvMul(lhs, rhs))
        let resValueInt = context.makeBvToInt(res, isSigned: true)
        
        let solver = context.makeSolver()
        
        solver.assert([lhsValue, rhsValue, resValue])
        XCTAssertEqual(solver.check(), .satisfiable)
        
        if let model = solver.getModel() {
            XCTAssertEqual(model.intAny(resValueInt), 369)
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
        let context = Z3Context()

        // 9x9 matrix of integer variables
        var x: [[Z3Int]] = []
        for i in 0..<9 {
            x.append([])
            for j in 0..<9 {
                x[i].append(context.makeConstant(name: "x_\(i + 1)_\(j + 1)", sort: IntSort.self))
            }
        }

        // each cell contains a value in {1, ..., 9}
        var cellsC: [[Z3Bool]] = []
        for i in 0..<9 {
            cellsC.append([])
            for j in 0..<9 {
                cellsC[i].append(1 <= x[i][j] && x[i][j] <= 9)
            }
        }

        // each row contains a digit at most once
        var rowsC: [Z3Bool] = []
        for i in 0..<9 {
            rowsC.append(context.makeDistinct(x[i]))
        }

        // each column contains a digit at most once
        var colsC: [Z3Bool] = []
        for j in 0..<9 {
            var column: [Z3Int] = []
            for i in 0..<9 {
                column.append(x[i][j])
            }

            colsC.append(context.makeDistinct(column))
        }

        // each 3x3 square contains a digit at most once
        var sqC: [[Z3Bool]] = []
        for i0 in 0..<3 {
            sqC.append([])
            for j0 in 0..<3 {
                var square: [Z3Int] = []
                for i in 0..<3 {
                    for j in 0..<3 {
                        square.append(x[3 * i0 + i][3 * j0 + j])
                    }
                }

                sqC[i0].append(context.makeDistinct(square))
            }
        }

        var sudokuC = context.makeTrue()
        for t in cellsC {
            sudokuC = sudokuC && context.makeAnd(t)
        }
        sudokuC = sudokuC && context.makeAnd(rowsC)
        sudokuC = sudokuC && context.makeAnd(colsC)
        for t in sqC {
            sudokuC = sudokuC && context.makeAnd(t)
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

        var instanceC = context.makeTrue()
        for i in 0..<9 {
            for j in 0..<9 {
                instanceC =
                    instanceC &&
                    context.makeIfThenElse(
                        instance[i][j] == context.makeInteger(0),
                        context.makeTrue(),
                        x[i][j] == instance[i][j]
                    )
            }
        }

        let s = context.makeSolver()
        s.assert(sudokuC)
        s.assert(instanceC)

        if s.check() == .satisfiable {
            let m = s.getModel()!
            var r: [[AnyZ3Ast]] = []
            for i in 0..<9 {
                r.append([])
                for j in 0..<9 {
                    r[i].append(m.eval(x[i][j], completion: false)!)
                }
            }

            let rInt = r.map { $0.map { $0.numeralInt } }

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

            XCTAssertEqual(rInt, expected)
        } else {
            XCTFail("Failed to solve sudoku")
        }
    }
    
    func testTowersSample() {
        // Load and solve a Towers game:
        // https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/towers.html#6:4//2//2///3//4//3//2/////2//2///4,n1g1m
        
        enum Coordinate {
            case left(row: Int)
            case right(row: Int)
            case top(column: Int)
            case bottom(column: Int)
        }
        
        struct Hint {
            var coordinate: Coordinate
            var hint: Int32
        }
        
        func calculateTargetSum(coordinate: Coordinate, grid: [[Z3Int]], context: Z3Context) -> Z3Int {
            let gridSize = grid.count
            
            var sum = context.makeInteger(1)
            
            var gridSubset: [Z3Int] = []
            
            switch coordinate {
            case .left(let row):
                gridSubset = grid[row]
                
            case .right(let row):
                gridSubset = grid[row].reversed()
                
            case .top(let column):
                for y in 0..<gridSize {
                    gridSubset.append(grid[y][column])
                }
                
            case .bottom(let column):
                for y in (0..<gridSize).reversed() {
                    gridSubset.append(grid[y][column])
                }
            }
            
            // Make a sequence that compares, one step at a time, the subset of
            // the input array with the next element, like so:
            //
            // [1] 5 3 4 2 -> max([1])             > 5
            // [1 5] 3 4 2 -> max([1, 5])          > 3
            // [1 5 3] 4 2 -> max([1, 5, 3])       > 4
            // [1 5 3 4] 2 -> max([1, 5, 3, 4])    > 2
            //
            // Sum one to the result for every comparison above that is true.
            for i in 0..<(gridSubset.count - 1) {
                let subset = gridSubset[0...i]
                
                let subsetMax: Z3Int
                if subset.count == 1 {
                    subsetMax = subset[0]
                } else {
                    subsetMax = subset.dropFirst().reduce(subset[0]) {
                        context.makeIfThenElse($0 > $1, $0, $1)
                    }
                }
                
                let subsetNext = gridSubset[i + 1]
                
                sum = sum + context.makeIfThenElse(
                    subsetMax < subsetNext,
                    context.makeInteger(1),
                    context.makeInteger(0)
                )
            }
            
            return sum
        }
        
        func makeTarget(hint: Hint, grid: [[Z3Int]], context: Z3Context) -> Z3Bool {
            let targetArray = calculateTargetSum(coordinate: hint.coordinate, grid: grid, context: context)
            
            return targetArray == context.makeInteger(hint.hint)
        }
        
        let context = Z3Context()
        
        let gridSize = 6
        var grid: [[Z3Int]] = []
        for x in 0..<gridSize {
            grid.append([])
            for y in 0..<gridSize {
                grid[x].append(
                    context.makeConstant(name: "x_\(x + 1)_\(y + 1)",
                                         sort: IntSort.self)
                )
            }
        }
        
        // each cell contains a value in {1, ..., gridSize}
        var cellsC: [[Z3Bool]] = []
        for i in 0..<gridSize {
            cellsC.append([])
            for j in 0..<gridSize {
                cellsC[i].append(1 <= grid[i][j] && grid[i][j] <= Int32(gridSize))
            }
        }
        
        // each row contains a digit at most once
        var rowsC: [Z3Bool] = []
        for i in 0..<gridSize {
            rowsC.append(context.makeDistinct(grid[i]))
        }

        // each column contains a digit at most once
        var colsC: [Z3Bool] = []
        for j in 0..<gridSize {
            var column: [Z3Int] = []
            for i in 0..<gridSize {
                column.append(grid[i][j])
            }

            colsC.append(context.makeDistinct(column))
        }
        
        var towersC = context.makeTrue()
        for t in cellsC {
            towersC = towersC && context.makeAnd(t)
        }
        towersC = towersC && context.makeAnd(rowsC)
        towersC = towersC && context.makeAnd(colsC)
        
        let hints: [Hint] = [
            Hint(coordinate: .top(column: 1), hint: 1),
            Hint(coordinate: .top(column: 2), hint: 3),
            Hint(coordinate: .top(column: 4), hint: 2),
            Hint(coordinate: .left(row: 2), hint: 3),
            Hint(coordinate: .left(row: 3), hint: 3),
            Hint(coordinate: .left(row: 4), hint: 2),
            Hint(coordinate: .right(row: 4), hint: 3),
            Hint(coordinate: .bottom(column: 3), hint: 4),
            Hint(coordinate: .bottom(column: 5), hint: 3),
        ]
        let initialGrid: [[Int32]] = [
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 0, 0, 0, 3],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
        ]
        
        var hintsC = context.makeTrue()
        for hint in hints {
            hintsC = hintsC && makeTarget(hint: hint, grid: grid, context: context)
        }
        
        var initialGridC = context.makeTrue()
        for i in 0..<gridSize {
            for j in 0..<gridSize where initialGrid[i][j] != 0 {
                initialGridC = initialGridC && grid[i][j] == initialGrid[i][j]
            }
        }

        let s = context.makeSolver()
        s.assert(towersC)
        s.assert(hintsC)
        s.assert(initialGridC)
        
        if s.check() == .satisfiable {
            let m = s.getModel()!
            var r: [[Z3Int]] = []
            for i in 0..<gridSize {
                r.append([])
                for j in 0..<gridSize {
                    r[i].append(m.eval(grid[i][j], completion: false)!)
                }
            }

            let rInt = r.map { $0.map { $0.numeralInt } }

            let expectedGrid: [[Int32]] = [
                [1, 6, 3, 2, 4, 5],
                [5, 3, 1, 6, 2, 4],
                [2, 5, 4, 1, 3, 6],
                [4, 1, 2, 5, 6, 3],
                [3, 2, 6, 4, 5, 1],
                [6, 4, 5, 3, 1, 2],
            ]
            
            XCTAssertEqual(rInt, expectedGrid)
        } else {
            XCTFail("Failed to solve Towers game")
        }
    }
    
    // Test that we override the default Z3_context error handler with a version
    // that does not exit() the application
    func testErrorHandler() {
        let context = Z3Context()
        let solver = context.makeSolver()
        
        XCTAssertThrowsError(try solver.fromString("an invalid SMT-LIB string"))
        XCTAssertNotEqual(context.errorCode, .ok)
    }

    func testTranslation() {
        let ctx1 = Z3Context()
        let ctx2 = Z3Context()

        let s1 = ctx1.intSort()
        let s2 = ctx1.intSort()
        let s3 = s1.translate(to: ctx2)

        XCTAssertEqual(s1, s2)
        XCTAssertNotEqual(s1, s3)
        XCTAssertNotEqual(s2, s3)

        let e1 = ctx1.makeConstant(name: "e1", sort: IntSort.self)
        let e2 = ctx1.makeConstant(name: "e1", sort: IntSort.self)
        let e3 = e1.translate(to: ctx2)

        XCTAssert(e1.isEqual(to: e2))
        XCTAssertFalse(e1.isEqual(to: e3))
        XCTAssertFalse(e2.isEqual(to: e3))
    }
}
