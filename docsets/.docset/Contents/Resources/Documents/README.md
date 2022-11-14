# SwiftZ3

[![Swift](https://github.com/LuizZak/swift-z3/actions/workflows/swift.yml/badge.svg)](https://github.com/LuizZak/swift-z3/actions/workflows/swift.yml)

A Swift wrapper over Microsoft's [Z3 Theorem Prover](https://github.com/Z3Prover/z3)

The aim is to wrap the entire C API layer into Swift types, with many conveniences and type safety sprinkled on top.

Example:

```swift
let config = Z3Config()
config.setParameter(name: "model", value: "true")

let context = Z3Context(configuration: config)

let left: Z3Float = context.makeConstant(name: "left")
let width: Z3Float = context.makeConstant(name: "width")
let right: Z3Float = context.makeConstant(name: "right")

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

Swift 5.4, macOS 10.13+

### Installation

SwiftZ3 is available to Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/LuizZak/swift-z3.git", .branch("master"))
]
```

Specific tagged versions of Z3 are available as branches instead of tags in this repository. This allows base Swift API updates on master to be merged into different release versions of Z3 without requiring rewriting tags:

```swift
dependencies: [
    .package(url: "https://github.com/LuizZak/swift-z3.git", .branch("4.11.2")) // Pulls 4.11.2 branch, with latest 'z3-4.11.2' source code + any API updates from master
]
```
