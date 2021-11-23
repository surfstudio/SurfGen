//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import XCTest
import UtilsForTesting

@testable import CodeGenerator

final class ResolverTests: XCTestCase {

    /// This method checks that specific practical case
    /// won't be considered as reference cycle
    func testPracticalCaseWontBeConsideredAsUnsupportedRefCycle() throws {
        // Arrange

        let pathToCatalogApi = "/project-swagger/catalog/api.yaml"
        let pathToCatalogModels = "/project-swagger/catalog/models.yaml"
        let pathToCommonAliases = "/project-swagger/common/aliases.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToCatalogApi: ResolverYamls.FalsePositiveReferenceCycle.catalogApi,
            pathToCatalogModels: ResolverYamls.FalsePositiveReferenceCycle.catalogModels,
            pathToCommonAliases: ResolverYamls.FalsePositiveReferenceCycle.commonAliases
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToCatalogApi)!))
    }

    // For details look at https://github.com/surfstudio/SurfGen/issues/46
    func testDoubledRefOnSameModelWontBeFoundAsUnsupportedReferenceCycle() throws {
        // Arrange

        let pathToModelsFile = "/project-swagger/catalog/models.yaml"
        let pathToApi = "/project-swagger/catalog/api.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToModelsFile: ResolverYamls.ModelWithDoubledRefs.model,
            pathToApi: ResolverYamls.ModelWithDoubledRefs.api,
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToApi)!))
    }

    // See https://github.com/surfstudio/SurfGen/issues/57
    func testRecursiveModelWillBeResolved() throws {
        // Arrange

        let pathToModelsFile = "/project-swagger/catalog/models.yaml"
        let pathToApi = "/project-swagger/catalog/api.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToModelsFile: ResolverYamls.RecursiveModel.model,
            pathToApi: ResolverYamls.RecursiveModel.api,
        ]

        var result = [[PathModel]]()
        var factory = StubGASTTreeFactory(fileProvider: fileProvider)
        factory.resultClosure = { (val: [[PathModel]]) throws -> Void in
            result = val.filter { $0.count != 0 }
        }
        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToApi)!)
        let responseWithRecursiveModel = result[0][0].operations[0].responses?[0].value.values[0]

        // Assert

        guard case let .object(model) = responseWithRecursiveModel?.type else {
            XCTFail("Schema with recursive model was not resolved as a model")
            return
        }

        guard case let .array(array) = model.properties[0].type, case let .reference(propertySchema) = array.itemsType else {
            XCTFail("Property of a recursive model was not resolved as a reference")
            return
        }

        guard case let .object(propertyModel) = propertySchema else {
            XCTFail("Schema of a recursive model property was not resolved as a model")
            return
        }

        XCTAssertEqual(model.name, propertyModel.name)

    }
}
