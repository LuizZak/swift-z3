// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "SwiftZ3",
    products: [
        .library(
            name: "SwiftZ3",
            targets: ["SwiftZ3"]),
        .library(
            name: "CZ3",
            targets: ["CZ3"]),
        .executable(
            name: "SwiftZ3Sample",
            targets: ["SwiftZ3Sample"]),
    ],
    targets: [
        .target(
            name: "CZ3",
            dependencies: [],
            cSettings: [
                .headerSearchPath("z3"),
                .define("_MP_INTERNAL"),
                .define("_WINDOWS", .when(platforms: [.windows])),
            ],
            cxxSettings: [
                .headerSearchPath("z3"),
                .define("_MP_INTERNAL"),
                .define("_WINDOWS", .when(platforms: [.windows])),
            ]),
        .target(
            name: "SwiftZ3",
            dependencies: ["CZ3"]),
        .executableTarget(
            name: "SwiftZ3Sample",
            dependencies: ["SwiftZ3", "CZ3"]),
        .testTarget(
            name: "SwiftZ3Tests",
            dependencies: ["SwiftZ3", "CZ3"]),
    ],
    cxxLanguageStandard: .cxx17
)
