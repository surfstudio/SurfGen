// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SurfGen",
    products: [
        .executable(name: "surfgen", targets: ["surfgen"]),
        .library(
            name: "SurfGenKit",
            targets: ["SurfGenKit"]),
        .library(
            name: "YamlParser",
            targets: ["YamlParser"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/JohnReeze/SwagGen/", from: "4.3.1"),
        .package(url: "https://github.com/stencilproject/Stencil", from: "0.13.1"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.3.3"),
        .package(url: "https://github.com/JohnReeze/XcodeProj", .upToNextMajor(from: "7.8.2")),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.5"),
        .package(url: "https://github.com/jpsim/Yams", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "surfgen",
            dependencies: [
                "SurfGenKit",
                "SwiftCLI",
                "YamlParser",
                "XcodeProj",
                "Rainbow",
                "Yams"
            ]
        ),
        .target(
            name: "SurfGenKit",
            dependencies: [
                "Stencil"
            ]
        ),
        .target(
            name: "YamlParser",
            dependencies: [
                "SurfGenKit",
                "Swagger"
            ]
        ),
        .testTarget(
            name: "SurfGenKitTests",
            dependencies: ["SurfGenKit"]
        ),
        .testTarget(
            name: "YamlParserTests",
            dependencies: ["YamlParser"]
        )
    ]
)
