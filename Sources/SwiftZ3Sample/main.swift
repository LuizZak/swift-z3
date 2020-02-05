import SwiftZ3

func main() {
    let config = Z3Config()
    config.setParameter(name: "model", value: "true")

    let context = Z3Context(configuration: config)

    let left = context.makeFloat(50)
    let width = context.makeFloat(100)
    let right = context.makeFloat(0)

    let rightEq = right == (left + width)
    
    let solver = context.makeSolver()
    
    solver.assert(rightEq)
    print(solver.check())
    
    if let model = solver.getModel() {
        print(model.double(right))
    }
}

main()
