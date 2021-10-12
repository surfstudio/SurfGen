// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var testTargets: [Target] = [
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
    ),
    .testTarget(
        name: "OperationsTests",
        dependencies: ["Operations"]
    )
]

var dependencies: [PackageDescription.Package.Dependency] = [
    // because SPM cant resolve it by their own ((((:
    // .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.0"),
    .package(url: "https://github.com/LastSprint/SwagGen", .revision("18ec072e675252e73f17174b56edd971d9b7a4b0")),
    .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.1"),
    .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.3"),
    .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.5"),
    .package(url: "https://github.com/jpsim/Yams", from: "1.0.0"),
]

let package = Package(
    name: "SurfGen",
    products: [

        // MARK: - Executable

        .executable(name: "SurfGen", targets: ["PipelinesCLI"]),

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
            name: "UtilsForTesting",
            targets: ["UtilsForTesting"]
        ),
        .library(
            name: "Operations",
            targets: ["Operations"]
        ),

        // MARK: -- Specific

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
        ),

        // MARK: -- Analytics

        .library (
            name: "AnalyticsClient",
            targets: ["AnalyticsClient"]
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
            name: "ReferenceExtractor",
            dependencies: [
                 "Yams",
                "Common"
            ]
        ),
        .target(
            name: "Pipelines",
            dependencies: [
                "ReferenceExtractor",
                "Common",
                "GASTBuilder",
                "GASTTree",
                "CodeGenerator",
                "Operations"
            ],
            exclude: ["main.swift", "CLI"]
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
            dependencies: [
                "Rainbow"
            ]
        ),
        .target(
            name: "GASTTree",
            dependencies: [
                "Swagger", 
                "Common"
            ]
        ),
        .target(
            name: "CodeGenerator",
            dependencies: [
                "GASTTree",
                "Common",
                "Stencil"
            ]
        ),
        .target(
            name: "PipelinesCLI",
            dependencies: [
                "Pipelines",
                "SwiftCLI",
                "AnalyticsClient"
            ],
            path: "Sources/Pipelines",
            sources: ["main.swift", "CLI"]
        ),
        .target(
            name: "AnalyticsClient",
            dependencies: [
                "Common"
            ]
        ),
        .target(
            name: "Operations"
        )
    ] + testTargets
)
