// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var testTargets: [Target] = [
    .testTarget(
        name: "SurfGenKitTests",
        dependencies: ["SurfGenKit"]
    ),
    .testTarget(
        name: "YamlParserTests",
        dependencies: ["YamlParser"]
    ),
    .testTarget(
        name: "EndToEndTests",
        dependencies: ["YamlParser", "SurfGenKit"]
    ),
    .testTarget(
        name: "RefereceExtractorTests",
        dependencies: ["ReferenceExtractor", "Common"]
    ),
    .testTarget(
        name: "PipelinesTests",
        dependencies: ["Pipelines", "CodeGenerator", "Common", "ReferenceExtractor", "GASTBuilder", "UtilsForTesting"]
    ),
    .testTarget(
        name: "CodeGeneratorTests",
        dependencies: ["Pipelines", "CodeGenerator", "Common", "ReferenceExtractor", "GASTBuilder", "UtilsForTesting"]
    )
]

var dependencies: [PackageDescription.Package.Dependency] = [
    .package(url: "https://github.com/jpsim/Yams", from: "1.0.0"),
    .package(url: "https://github.com/LastSprint/SwagGen", .revision("4fd5a299db0ba733e5cd6fa4e421b40248657cb6")),
    .package(url: "https://github.com/stencilproject/Stencil", from: "0.13.1"),
    .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.3.3"),
    .package(url: "https://github.com/JohnReeze/XcodeProj", .upToNextMajor(from: "7.8.2")),
    .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.5")
]

let package = Package(
    name: "SurfGen",
    products: [

        // MARK: - Executable

        .executable(name: "surfgen", targets: ["surfgen"]),
        .executable(name: "PipelineRunnerCLI", targets: ["PipelinesCLI"]),

        // MARK: - Libs

        // MARK: -- Shared

        .library(
            name: "GASTTree",
            targets: ["GASTTree"]
        ),
        .library(
            name: "Common",
            targets: ["Common"]
        ),
        .library(
            name: "Pipelines",
            targets: ["Pipelines"]
        ),
        .library(
            name: "SurfGenKit",
            targets: ["SurfGenKit"]
        ),
        .library(
            name: "UtilsForTesting",
            targets: ["UtilsForTesting"]
        ),

        // MARK: -- Specific

        .library(
            name: "YamlParser",
            targets: ["YamlParser"]
        ),
        .library(
            name: "ReferenceExtractor",
            targets: ["ReferenceExtractor"]
        ),
        .library(
            name: "GASTBuilder",
            targets: ["GASTBuilder"]
        ),
        .library(
            name: "CodeGenerator",
            targets: ["CodeGenerator"]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "UtilsForTesting",
            dependencies: [
                "Pipelines",
                "CodeGenerator",
                "Common",
                "ReferenceExtractor",
                "GASTBuilder"
            ]
        ),
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
            name: "ReferenceExtractor",
            dependencies: [
                "Yams",
                "Common"
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
        .target(
            name: "Pipelines",
            dependencies: [
                "ReferenceExtractor",
                "Common",
                "GASTBuilder",
                "GASTTree",
                "CodeGenerator"
            ],
            exclude: ["main.swift"]
        ),
        .target(
            name: "GASTBuilder",
            dependencies: [
                "Yams",
                "Swagger",
                "Common",
                "GASTTree"
            ]
        ),
        .target(
            name: "Common",
            dependencies: ["Rainbow"]
        ),
        .target(
            name: "GASTTree",
            dependencies: ["Swagger", "Common"]
        ),
        .target(
            name: "CodeGenerator",
            dependencies: ["GASTTree", "Common"]
        ),
        .target(
            name: "PipelinesCLI",
            dependencies: [
                "Pipelines"
            ],
            path: "Sources/Pipelines",
            sources: ["main.swift"]
        )
    ] + testTargets
)
