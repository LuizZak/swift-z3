// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftZ3",
    products: [
        .library(
            name: "SwiftZ3",
            type: .dynamic,
            targets: ["SwiftZ3"]),
        .executable(
            name: "SwiftZ3Sample",
            targets: ["SwiftZ3Sample"]),
    ],
    targets: [
        .target(
            name: "Z3",
            dependencies: [],
            cSettings: [
                .headerSearchPath("./"),
                .define("_MP_INTERNAL")
            ],
            cxxSettings: [
                .headerSearchPath("./"),
                .define("_MP_INTERNAL")
            ]),
        .target(
            name: "SwiftZ3",
            dependencies: ["Z3"]),
        .target(
            name: "SwiftZ3Sample",
            dependencies: ["SwiftZ3", "Z3"]),
        .testTarget(
            name: "SwiftZ3Tests",
            dependencies: ["SwiftZ3", "Z3"]),
    ],
    cxxLanguageStandard: .cxx11
)
