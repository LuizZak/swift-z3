import SwiftZ3

func main() {
    let config = Z3Config()
    config.setParameter(name: "model", value: "true")

    let context = Z3Context(configuration: config)
    
    let roundMode = context.makeFpaRoundTowardZero()
    let left = context.makeFpaNumeralFloat(50, sort: FP32Sort.self)
    let width = context.makeFpaNumeralFloat(100, sort: FP32Sort.self)
    let right = context.makeFpaNumeralFloat(0, sort: FP32Sort.self)
    
    let rightEq = context.makeFpaEq(right, context.makeFpaAdd(roundMode, left, width))
    
    let solver = context.makeSolver()
    
    solver.assert(rightEq)
    print(solver.check())
    
    if let model = solver.getModel() {
        print(model.double(right))
    }
}
