//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import XCTest
import UtilsForTesting

final class ResolverTests: XCTestCase {

    /// This method checks that specific practical case
    /// won't be considered as reference cycle
    func testPracticalCaseWontBeConsideredAsRefCycle() throws {
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
    func testDoubledRefOnSameModelWontBeFoundAsReferenceCycle() throws {
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
}
