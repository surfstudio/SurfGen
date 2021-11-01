//
//  EndtoEndTests.swift
//  
//
//  Created by Александр Кравченков on 26.10.2021.
//

import Foundation
import Common
import XCTest
import Pipelines
import ReferenceExtractor

@testable import ASTTree
@testable import UtilsForTesting

final class EndtoEndTests: XCTestCase {

    public static func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: FileManager.default
        )
    }

    func getPipeline(excluder: ASTNodeExcluder,
                     excludeList: Set<String>,
                     result: AnyPipelineStage<[OpenAPIASTTree]>) -> BuildGASTTreeEntryPoint {
        return .init(
            refExtractorProvider: EndtoEndTests.provider,
            next: OpenAPIASTBuilderStage(
                fileProvider: FileManager.default,
                next: OpenAPIASTExcludingStage(
                    excluder: excluder,
                    excludeList: excludeList,
                    next: result
                ).erase()
            ).erase()
        )
    }

    let testFolderUrl = URL(string: #file)! //.../SurfGen/Tests/ASTTreeTree/ASTNodeExcluderTree/IsNeedToReplaceReferenceTests.swift
        .deletingLastPathComponent() //.../SurfGen/Tests/ASTTreeTree/ASTNodeExcluderTree/
        .deletingLastPathComponent() //.../SurfGen/Tests/ASTTreeTree/
        .deletingLastPathComponent() //.../SurfGen/Tests/


    func testEmptyExcludeList() throws {
        // Arrange

        let baseUrl = testFolderUrl.appendingPathComponent("Common/ProjectA/auth/models.yaml")
        let excluder = ASTNodeExcluder(logger: DefaultLogger.verbose)
        let name = "ISO8601Date"
        let excludeList = Set<String>()
        let pathToFile = testFolderUrl.absoluteString + "Common/ProjectA/common/aliases.yaml"

        let resultStage = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let pipeline = self.getPipeline(excluder: excluder, excludeList: excludeList, result: resultStage.erase())

        // Act

        try pipeline.run(with: baseUrl)

        // Assert

        let result = resultStage.input?
            .first(where: {$0.rawDependency.pathToCurrentFile == pathToFile })?
            .currentTree.components.schemas.first(where: { $0.name == name })

        XCTAssertNotNil(result)
    }

    func testRemovingShemaNodeWorks() throws {
        // Arrange

        let baseUrl = testFolderUrl.appendingPathComponent("Common/ProjectA/auth/models.yaml")
        let excluder = ASTNodeExcluder(logger: DefaultLogger.verbose)
        let name = "ISO8601Date"
        let excludeList = [
            testFolderUrl.absoluteString + "Common/ProjectA/common/aliases.yaml#/components/schemas/\(name)"
        ]

        let resultStage = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let pipeline = self.getPipeline(excluder: excluder, excludeList: Set(excludeList), result: resultStage.erase())

        // Act

        try pipeline.run(with: baseUrl)

        // Assert

        XCTAssertNotNil(resultStage.input)

        let tree = resultStage.input?
            .first(where: {$0.rawDependency.pathToCurrentFile == excludeList[0].split(separator: "#").map { String($0)}[0] })

        XCTAssertNotNil(tree)

        let result = tree?.currentTree.components.schemas.first(where: { $0.name == name })

        XCTAssertNil(result)
    }

    func testReferenceChangeWork() throws {

        // Arrange

        let baseUrl = testFolderUrl.appendingPathComponent("Common/ProjectA/auth/models.yaml")
        let excluder = ASTNodeExcluder(logger: DefaultLogger.verbose)
        let name = "ISO8601Date"
        let excludeList = [
            testFolderUrl.absoluteString + "Common/ProjectA/common/aliases.yaml#/components/schemas/\(name)"
        ]

        let propertiesToCheckOnReferenceReplacements = ["issued", "expires"]

        let resultStage = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let pipeline = self.getPipeline(excluder: excluder, excludeList: Set(excludeList), result: resultStage.erase())

        // Act

        try pipeline.run(with: baseUrl)

        // Assert

        let modelToCheck = resultStage.input?
            .first(where: {$0.rawDependency.pathToCurrentFile == baseUrl.absoluteString })?
            .currentTree.components.schemas.first(where: { $0.name == "AuthResponse" })

        guard let modelToCheck = modelToCheck else {
            XCTFail("AuthResponse not found")
            return
        }

        switch modelToCheck.value.type {
        case .object(let obj):
            obj.properties.forEach { prop in
                guard propertiesToCheckOnReferenceReplacements.contains(prop.name) else { return }

                switch prop.schema.type {
                case .reference(let ref):
                    XCTAssertEqual(ref.rawValue, Constants.ASTNodeReference.todo)
                default:
                    XCTFail("Excpected reference property type but found \(prop)")
                }
            }
        default:
            XCTFail("Excpected object type but found \(modelToCheck.value.type)")
        }

    }

    func testCaseWithAliasWithTypeAny() throws {
        // Arrange

        let baseUrl = testFolderUrl.appendingPathComponent("Common/NodeExcluding/models.yaml")
        let excluder = ASTNodeExcluder(logger: DefaultLogger.verbose)
        let name = "BadModel"
        let excludeList = [
            testFolderUrl.absoluteString + "Common/NodeExcluding/models.yaml#/components/schemas/\(name)"
        ]

        let resultStage = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let pipeline = self.getPipeline(excluder: excluder, excludeList: Set(excludeList), result: resultStage.erase())

        // Act

        try pipeline.run(with: baseUrl)

        // Assert

        XCTAssertNotNil(resultStage.input)

        let tree = resultStage.input?
            .first(where: {$0.rawDependency.pathToCurrentFile == excludeList[0].split(separator: "#").map { String($0)}[0] })

        XCTAssertNotNil(tree)

        let result = tree?.currentTree.components.schemas.first(where: { $0.name == name })

        XCTAssertNil(result)
    }

    func testPathRemoving() throws {
        // Arrange

        let baseUrl = testFolderUrl.appendingPathComponent("Common/NodeExcluding/api.yaml")
        let excluder = ASTNodeExcluder(logger: DefaultLogger.verbose)
        let path = "/paths/api/v1.1/superAuth"
        let method = "delete"

        let excludeList = [
            testFolderUrl.absoluteString + "Common/NodeExcluding/api.yaml#\(path)~\(method)"
        ]

        let resultStage = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let pipeline = self.getPipeline(excluder: excluder, excludeList: Set(excludeList), result: resultStage.erase())

        // Act

        try pipeline.run(with: baseUrl)

        // Assert

        XCTAssertNotNil(resultStage.input)

        let tree = resultStage.input?
            .first(where: {$0.rawDependency.pathToCurrentFile == excludeList[0].split(separator: "#").map { String($0)}[0] })

        XCTAssertNotNil(tree)

        let pathModel = tree?.currentTree.paths.first(where: { $0.path == path })

        XCTAssertNotNil(path)

        let opertation = pathModel?.operations.first(where: { $0.method.rawValue == method })

        XCTAssertNil(opertation)
    }


}
