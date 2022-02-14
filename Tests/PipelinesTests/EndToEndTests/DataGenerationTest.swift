//
//  File.swift
//  
//
//  Created by volodina on 14.02.2022.
//

import Foundation
import Pipelines
import XCTest
import UtilsForTesting
import CodeGenerator

class DataGenerationTest: XCTestCase {
    
    func testDataGeneration() throws {
        // Arrange

        let specUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/ProjectA/catalog/api.yaml")

        let stage = AnyPipelineStageStub<[[PathModel]]>()
        // Act

        try StubBuildCodeGeneratorPipelineFactory.build(
            templates: [],
            astNodesToExclude: [],
            serviceName: "Catalog",
            stage: stage.erase(),
            useNewNullableDefinitionStartegy: false
        ).run(with: specUrl)

        // Assert
        guard let pathes = stage.result?.first else {
            XCTFail()
            return
        }
        for item in pathes {
            print(item.apiDefinitionFileRef)
        }
        // todo
    }
}
