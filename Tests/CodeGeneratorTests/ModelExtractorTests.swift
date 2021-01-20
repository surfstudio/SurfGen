//
//  ModelExtractorTests.swift
//  
//
//  Created by Dmitry Demyanov on 15.01.2021.
//

import Foundation
@testable import CodeGenerator
import UtilsForTesting
import XCTest

class ModelExtractorTests: XCTestCase {

    func testAllModelsFromSampleSpecAreExtracted() throws {
        // Arrange

        let specUrl = URL(string: #file)! //.../SurfGen/Tests/CodeGeneratorTests/ModelExtractorTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/CodeGeneratorTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/ProjectA/catalog/api.yaml")

        var serviceModel: [PathModel] = []

        let fileProvider = FileManager()
        let _ = try StubGASTTreeFactory(fileProvider: fileProvider) {
            serviceModel = $0.filter { $0.count != 0 }.first!
        }.build().run(with: specUrl)

        let generationModel = ServiceGenerationModel(name: "", paths: serviceModel)
        let modelExtractor = ModelExtractor()

        let expectedNames = Set([
            "CatalogItem",
            "CommonError",
            "InfoMessage",
            "Service",
            "ServiceStatus",
            "SetTariffRequest",
            "SubscriptionInfo",
            "TariffInfo",
            "Tariffs"
        ])

        // Act

        let models = modelExtractor.extractModels(from: generationModel)
        let modelNames = Set(models.map { $0.name })

        // Assert

        XCTAssertEqual(modelNames, expectedNames)
    }
}
