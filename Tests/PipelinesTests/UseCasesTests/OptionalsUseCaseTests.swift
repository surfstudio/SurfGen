//
//  OptionalsUseCaseTests.swift
//  
//
//  Created by Александр Кравченков on 24.08.2021.
//

import Foundation
import XCTest
import CodeGenerator
import GASTTree
import UtilsForTesting


/// Cases:
///
/// - If property in object has `optional: true` then it should be optional
/// - If property in object has `optional: false` then it shouldn't be optional
/// - If property in object doesn't have `optional` parameter then property shouldn't be optional
public class OptionalsUseCaseTests: XCTestCase {

    /// If property in object has `optional: true` then it should be optional
    func testOptionalTrueMark() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModel = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: OptionalsUseCaseYamls.objectPath,
            pathToModel: OptionalsUseCaseYamls.schemaWithNullableTrue
        ]

        var result = [[PathModel]]()

        var factory = StubGASTTreeFactory(fileProvider: fileProvider, resultClosure: { result = $0 })
        factory.useNewNullableDeterminationStrategy = true
        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let response = result.last?.last?.operations.last?.responses?.last else {
            XCTFail("Response not found")
            return
        }

        guard case Reference<ResponseModel>.notReference(let respModel) = response else {
            XCTFail("Unexpected response")
            return
        }

        guard case DataModel.PossibleType.object(let object) = respModel.values.last!.type else {
            XCTFail("Unexpected schema type in response")
            return
        }


        XCTAssertTrue(object.properties.last!.isNullable)
    }

    /// If property in object has `optional: false` then it shouldn't be optional
    func testOptionalFalseMark() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModel = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: OptionalsUseCaseYamls.objectPath,
            pathToModel: OptionalsUseCaseYamls.schemaWithNullableFalse
        ]

        var result = [[PathModel]]()

        var factory = StubGASTTreeFactory(fileProvider: fileProvider, resultClosure: { result = $0 })
        factory.useNewNullableDeterminationStrategy = true
        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let response = result.last?.last?.operations.last?.responses?.last else {
            XCTFail("Response not found")
            return
        }

        guard case Reference<ResponseModel>.notReference(let respModel) = response else {
            XCTFail("Unexpected response")
            return
        }

        guard case DataModel.PossibleType.object(let object) = respModel.values.last!.type else {
            XCTFail("Unexpected schema type in response")
            return
        }


        XCTAssertFalse(object.properties.last!.isNullable)
    }

    /// If property in object doesn't have `optional` parameter then property shouldn't be optional
    func testNoOptionalFalseMark() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModel = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: OptionalsUseCaseYamls.objectPath,
            pathToModel: OptionalsUseCaseYamls.schemaWithoutNullable
        ]

        var result = [[PathModel]]()

        var factory = StubGASTTreeFactory(fileProvider: fileProvider, resultClosure: { result = $0 })
        factory.useNewNullableDeterminationStrategy = true
        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let response = result.last?.last?.operations.last?.responses?.last else {
            XCTFail("Response not found")
            return
        }

        guard case Reference<ResponseModel>.notReference(let respModel) = response else {
            XCTFail("Unexpected response")
            return
        }

        guard case DataModel.PossibleType.object(let object) = respModel.values.last!.type else {
            XCTFail("Unexpected schema type in response")
            return
        }


        XCTAssertFalse(object.properties.last!.isNullable)
    }
}
