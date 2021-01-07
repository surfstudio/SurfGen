//
//  File.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation
import Common
import XCTest

@testable import Pipelines

public final class OpenAPILinterTests: XCTestCase {

    final class NextStub: PipelineEntryPoint {

        var got: [URL]

        init() {
            self.got = []
        }

        func run(with input: [URL]) throws {
            got.append(contentsOf: input)
        }
    }

    public func testSingleFileWillBeReadSuccessfully() throws {
        // Arrange

        let baseUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/LinterTests/RealDataTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/LinterTests/
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/
            .appendingPathComponent("CommonTestSpecs/auth/models.yaml")

        let stub = NextStub()
        let current = OpenAPILinter(
            filesToIgnore: [],
            next: stub.erase(),
            log: DefaultLogger.verbose
        )

        // Act

        try current.run(with: baseUrl.absoluteString)

        // Assert

        XCTAssertEqual(stub.got.count, 1)
        XCTAssertEqual(stub.got[0].absoluteString, baseUrl.absoluteString)
    }

    public func testDirWillBeReadSuccessfully() throws {
        // Arrange

        let baseUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/LinterTests/RealDataTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/LinterTests/
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/
            .appendingPathComponent("CommonTestSpecs")

        let stub = NextStub()
        let current = OpenAPILinter(
            filesToIgnore: [],
            next: stub.erase(),
            log: DefaultLogger.verbose
        )

        // Act

        try current.run(with: baseUrl.absoluteString)

        // Assert

        XCTAssertEqual(stub.got.count, 34)
    }

    public func testFileExcludingWorkCorrectly() throws {
        // Arrange

        let baseUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/LinterTests/RealDataTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/LinterTests/
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/
            .appendingPathComponent("CommonTestSpecs")

        let filesToExlude = [
            baseUrl.appendingPathComponent("/auth/models.yaml").absoluteString,
            baseUrl.appendingPathComponent("/user/models.yaml").absoluteString
        ]

        let stub = NextStub()
        let current = OpenAPILinter(
            filesToIgnore: Set(filesToExlude),
            next: stub.erase(),
            log: DefaultLogger.verbose
        )

        // Act

        try current.run(with: baseUrl.absoluteString)

        // Assert

        XCTAssertEqual(stub.got.count, 34 - filesToExlude.count)
    }
}
