// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModelsCodeGeneration",
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
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.3.3")
    ],
    targets: [
        .target(
            name: "surfgen",
            dependencies: [
                "SurfGenKit",
                "SwiftCLI",
                "YamlParser"
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
        )
    ]
)
