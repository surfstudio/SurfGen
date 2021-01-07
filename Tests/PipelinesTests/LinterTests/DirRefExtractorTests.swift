//
//  File.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation
import XCTest
import Common
import ReferenceExtractor

@testable import Pipelines

public final class DirRefExtractorTests: XCTestCase {

    class NextStub: PipelineStage {

        var got = [Dependency]()

        func run(with input: [Dependency]) throws {
            self.got.append(contentsOf: input)
        }
    }

    func testSingleFileWillExtracted() throws {
        // Arrange

        let baseUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/LinterTests/RealDataTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/LinterTests/
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/
            .appendingPathComponent("CommonTestSpecs/auth/models.yaml")

        let stub = NextStub()
        let current = OpenAPILinter(
            filesToIgnore: [],
            next: DirRefExtractor(
                refExtractorProvider: { try .init(pathToSpec: $0, fileProvider: FileManager.default) },
                next: stub.erase()
            ).erase(),
            log: DefaultLogger.verbose
        )

        // Act

        try current.run(with: baseUrl.absoluteString)

        // Assert

        XCTAssertEqual(stub.got.count, 3)
    }

    func testDirWillExtracted() throws {
        // Arrange

        let baseUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/LinterTests/RealDataTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/LinterTests/
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/
            .appendingPathComponent("CommonTestSpecs")

        let stub = NextStub()
        let current = OpenAPILinter(
            filesToIgnore: [],
            next: DirRefExtractor(
                refExtractorProvider: { try .init(pathToSpec: $0, fileProvider: FileManager.default) },
                next: stub.erase()
            ).erase(),
            log: DefaultLogger.verbose
        )

        // Act

        try current.run(with: baseUrl.absoluteString)

        // Assert

        XCTAssertEqual(stub.got.count, 34)
    }
}
