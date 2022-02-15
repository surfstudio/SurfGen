//
//  DataGenerationTest.swift
//  
//
//  Created by volodina on 14.02.2022.
//

import Foundation
import Pipelines
import XCTest
import UtilsForTesting
import CodeGenerator
import Common

/// The test checks if apiDefinitionFileRef is present for each response model
class DataGenerationTest: XCTestCase {
    
    func testDataGeneration() throws {
        // Arrange

        let testedApiUrl = "auth/api.yaml"
        let specUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/PackageSeparation/\(testedApiUrl)")

        let stage = AnyPipelineStageStub<[[PathModel]]>()
        // Act

        try StubBuildCodeGeneratorPipelineFactory.build(
            templates: [],
            astNodesToExclude: [],
            serviceName: "PackageSeparation",
            stage: stage.erase(),
            useNewNullableDefinitionStartegy: false
        ).run(with: specUrl)

        // Assert
        
        // PathModel for /test
        guard let testPath = stage.result?.last?.first else {
            XCTFail("Test api path not found")
            return
        }

        // OperationModel for /test
        guard let testOperation = testPath.operations.first else {
            XCTFail("Tested operation not found")
            return
        }
        
        // RequestModel for /test
        guard case DataModel.PossibleType.object(let requestModel) = testOperation.requestModel!.value.content.first!.type else {
            XCTFail("Error while request model casting")
            return
        }
        
        XCTAssertTrue(testPath.apiDefinitionFileRef.hasSuffix(testedApiUrl))
        XCTAssertTrue(requestModel.apiDefinitionFileRef.hasSuffix("auth/models.yaml"))
        
        // Request parameter schema for /test
        guard case ParameterModel.PossibleType.reference(let requestParameterSchema) = testOperation.parameters!.first!.value.type else {
            XCTFail("Error while request parameter schema casting")
            return
        }
        
        // Request parameter for /test
        guard case SchemaType.enum(let requestParameter) = requestParameterSchema else {
            XCTFail("Error while request parameter casting")
            return
        }
        
        XCTAssertTrue(requestParameter.apiDefinitionFileRef.hasSuffix("very/long/dir/models.yaml"))
        
        for requestProperty in requestModel.properties {
            switch requestProperty.type {
            case .reference(_): do {
                guard case PropertyModel.PossibleType.reference(let propertySchema) = requestProperty.type else {
                    XCTFail("Error while property \(requestProperty.name) schema casting")
                    return
                }
                guard case SchemaType.object(let propertyModel) = propertySchema else {
                    XCTFail("Error while property \(requestProperty.name) casting")
                    return
                }
                let assertedSuffix = try getModelApiFile(model: propertyModel.name)
                XCTAssertTrue(propertyModel.apiDefinitionFileRef.hasSuffix(assertedSuffix))
            }
            default:
                continue
            }
        }
    }
    
    /// returns a file name where the model belongs
    private func getModelApiFile(model: String) throws -> String {
        switch model {
        case "Error":
            return "very/long/dir/models.yaml"
        case "Product":
            return "products/models.yaml"
        case "User":
            return "profile/models.yaml"
        default:
            throw CommonError(message: "Unexpected \(model)")
        }
    }
}
