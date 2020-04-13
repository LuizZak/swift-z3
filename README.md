# SwiftZ3

| Platform | Build Status |
|----------|--------|
| macOS    | [![Build Status](https://dev.azure.com/luiz-fs/swift-z3/_apis/build/status/LuizZak.swift-z3?branchName=master&jobName=macOS)](https://dev.azure.com/luiz-fs/swift-z3/_build/latest?definitionId=5&branchName=master) |
| Linux    | [![Build Status](https://dev.azure.com/luiz-fs/swift-z3/_apis/build/status/LuizZak.swift-z3?branchName=master&jobName=Linux)](https://dev.azure.com/luiz-fs/swift-z3/_build/latest?definitionId=5&branchName=master) |

A Swift wrapper over Microsoft's [Z3 Theorem Prover](https://github.com/Z3Prover/z3)

The aim is to wrap the entire C API layer into Swift types, with many conveniences and type safety sprinkled on top.

Example:

```swift
let config = Z3Config()
config.setParameter(name: "model", value: "true")

let context = Z3Context(configuration: config)

let left = context.makeConstant(name: "left", sort: Float.self)
let width = context.makeConstant(name: "width", sort: Float.self)
let right = context.makeConstant(name: "right", sort: Float.self)

let lValue = left == 50.0
let wValue = width == 100.0

let rightEq = right == left + width

let solver = context.makeSolver()

solver.assert([lValue, wValue, rightEq])
XCTAssertEqual(solver.check(), .satisfiable)

if let model = solver.getModel() {
    XCTAssertEqual(model.double(right), 150)
} else {
    XCTFail("Failed to get expected model")
}
```

Development is ongoing and the public API might change at any time without notice.

### Requirements

Swift 5.2

### Instalation

SwiftZ3 is available to Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/LuizZak/swift-z3.git", .branch("master"))
]
```
