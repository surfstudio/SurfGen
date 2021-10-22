//
//  OpenAPIASTBuilder.swift
//  
//
//  Created by Александр Кравченков on 21.10.2021.
//

import Foundation
import XCTest
import Pipelines
import Common
import UtilsForTesting

/// Cases:
/// 1. Empty input leads to empty result
/// 2. Structure of result object is similar to structure of input objects
/// 3. If there is no file by the path then an error will be throwed
final class OpenAPIASTBuilderTests: XCTestCase {


    /// 1. Empty input leads to empty result
    func testEmptyInputLeadsToEmptyResult() throws {
        // Arrange

        let fileProviderStub = FileProviderStub()
        let nextStub = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let data = [Dependency]()
        let stage = OpenAPIASTBuilder(fileProvider: fileProviderStub, next: nextStub.erase())

        // Act

        try stage.run(with: data)

        // Assert

        XCTAssertEqual(data.count, nextStub.result?.count)
    }

    /// 2. Structure of result object is similar to structure of input objects
    func testStructOfResultIsSimilarToStructOfInput() throws {
        // Arrange

        let fileProviderStub = FileProviderStub()

        fileProviderStub.files = [
            "dep1": OpenAPIASTBuilderTestsYamls.modelA,
            "dep2": OpenAPIASTBuilderTestsYamls.modelB,
            "dep3": OpenAPIASTBuilderTestsYamls.modelC
        ]

        let filePathAndModelTitle = [
            "dep1": "ModelA",
            "dep2": "ModelB",
            "dep3": "ModelC",
        ]

        let refPathAndModelTitle = [
            "dep1ref": "ModelA",
            "dep2ref": "ModelB",
            "dep3ref": "ModelC",
        ]

        let nextStub = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let input = [
            Dependency(pathToCurrentFile: "dep1", dependecies: [
                "dep2ref": "dep2",
                "dep3ref": "dep3"
            ]),
            Dependency(pathToCurrentFile: "dep2", dependecies: [
                "dep3ref": "dep3",
                "dep1ref": "dep1",
            ]),
            Dependency(pathToCurrentFile: "dep3", dependecies: [
                "dep3ref": "dep3",
                "dep1ref": "dep1",
            ])
        ]

        let stage = OpenAPIASTBuilder(fileProvider: fileProviderStub, next: nextStub.erase())


        // Act

        try stage.run(with: input)

        // Assert

        guard let output = nextStub.result else {
            XCTFail("OpenAPIASTBuilder didn't pass any data to next stage")
            return
        }

        XCTAssertEqual(input.count, output.count)

        for i in 0..<output.count {

            // check that forest contains tree with exact dependency
            // (so we check that there is no the same trees and all trees was built from dependencies)
            guard let tree = output.first(where: {$0.rawDependency == input[i]}) else {
                XCTFail("OpenAPIASTBuilder doesn't produce tree for dependency \(input[i])")
                return
            }

            XCTAssertEqual(
                filePathAndModelTitle[input[i].pathToCurrentFile],
                tree.currentTree.components.schemas.first?.name
            )

            for j in 0..<tree.dependencies.keys.count {

                let index = input[i].dependecies.keys.index(input[i].dependecies.keys.startIndex, offsetBy: j)

                // same as before bot for subdependencies
                guard let subTree = tree.dependencies[input[i].dependecies.keys[index]] else {
                    XCTFail("Tree \(tree) doesn't contains subtree for dependency \(input[i].dependecies.keys[index])")
                    return
                }

                XCTAssertEqual(
                    refPathAndModelTitle[input[i].dependecies.keys[index]],
                    subTree.components.schemas.first?.name
                )
            }
        }
    }

    /// 3. If there is no file by the path then an error will be throwed
    func testIfThereIsNoFileByThePathThenAnErrorWillBeThrowed() throws {

        // Arrange

        let fileProviderStub = FileProviderStub()

        fileProviderStub.files = [
            "dep2": OpenAPIASTBuilderTestsYamls.modelB,
            "dep3": OpenAPIASTBuilderTestsYamls.modelC
        ]

        let nextStub = AnyPipelineStageStub<[OpenAPIASTTree]>()

        let input = [
            Dependency(pathToCurrentFile: "dep1", dependecies: [
                "dep2ref": "dep2",
                "dep3ref": "dep3"
            ]),
        ]

        let stage = OpenAPIASTBuilder(fileProvider: fileProviderStub, next: nextStub.erase())

        // Act - Assert

        XCTAssertThrowsError(try stage.run(with: input))
    }
}
