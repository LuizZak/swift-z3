// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftZ3",
    products: [
        .library(
            name: "SwiftZ3",
            targets: ["SwiftZ3"]),
    ],
    targets: [
        .target(
            name: "Z3",
            dependencies: [],
            cSettings: [
                .headerSearchPath("src"),
                .define("_MP_INTERNAL")
            ],
            cxxSettings: [
                .headerSearchPath("src"),
                .define("_MP_INTERNAL")
            ]),
        .target(
            name: "SwiftZ3",
            dependencies: ["Z3"]),
        .testTarget(
            name: "SwiftZ3Tests",
            dependencies: ["SwiftZ3", "Z3"]),
    ],
    cxxLanguageStandard: .cxx11
)
