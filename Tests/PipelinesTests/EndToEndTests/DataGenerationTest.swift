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

class DataGenerationTest: XCTestCase {
    
    /// Test if apiDefinitionFileRef is present for each response model
    func testApiDefinitionFileRef() throws {
        // Arrange

        let testedApiUrl = "auth/api.yaml"
        let homeUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/PackageSeparation")
        let specUrl = homeUrl.appendingPathComponent(testedApiUrl)
        let homePath = homeUrl.path

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
   
        XCTAssertEqual(testPath.apiDefinitionFileRef, "\(homePath)/\(testedApiUrl)")
        try testOperationParameters(testOperation: testOperation, homePath: homePath)
        try testRequestModel(testOperation: testOperation, homePath: homePath)
        try testResponseModel(testOperation: testOperation, homePath: homePath)
    }
    
    /// Test if destinationPath for each model supports package separation when the root is set
    func testDestinationPath() throws {
        // Arrange

        let testedApiUrl = "auth/api.yaml"
        let homeUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/PackageSeparation")
        let specUrl = homeUrl.appendingPathComponent(testedApiUrl)
        
        // Act, Assert
        try testDestinationPathUtil(specUrl: specUrl, homePath: homeUrl.path)
        try testDestinationPathUtil(specUrl: specUrl, homePath: "")
    }
    
    private func testOperationParameters(testOperation: OperationModel, homePath: String) throws {
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
    }
    
    private func testRequestModel(testOperation: OperationModel, homePath: String) throws {
        // RequestModel for /test
        guard case DataModel.PossibleType.object(let requestModel) = testOperation.requestModel!.value.content.first!.type else {
            XCTFail("Error while request model casting")
            return
        }
        XCTAssertEqual(requestModel.apiDefinitionFileRef, "\(homePath)/auth/models.yaml")
        try testProperties(properties: requestModel.properties, homePath: homePath)
    }
    
    private func testResponseModel(testOperation: OperationModel, homePath: String) throws {
        guard case DataModel.PossibleType.array(let responseModel) = testOperation.responses!.first!.value.values.first!.type else {
            XCTFail("Error while response model casting")
            return
        }
        guard case SchemaArrayModel.PossibleType.reference(let itemsType) = responseModel.itemsType else {
            XCTFail("Error while itemsType casting")
            return
        }
        guard case SchemaType.object(let objectModel) = itemsType else {
            XCTFail("Error while objectModel casting")
            return
        }
        XCTAssertEqual(objectModel.apiDefinitionFileRef, "\(homePath)/auth/models.yaml")
        try testProperties(properties: objectModel.properties, homePath: homePath)
    }
    
    private func testProperties(properties: [PropertyModel], homePath: String) throws {
        for property in properties {
            switch property.type {
            case .reference(_):
                guard case PropertyModel.PossibleType.reference(let propertySchema) = property.type else {
                    XCTFail("Error while property \(property.name) schema casting")
                    return
                }
                guard case SchemaType.object(let propertyModel) = propertySchema else {
                    XCTFail("Error while property \(property.name) casting")
                    return
                }
                let assertedSuffix = try getModelApiFile(model: propertyModel.name)
                XCTAssertEqual(
                    propertyModel.apiDefinitionFileRef,
                    "\(homePath)/\(assertedSuffix)"
                )
            default:
                continue
            }
        }
    }
    
    private func testDestinationPathUtil(specUrl: URL, homePath: String) throws {
        // Arrange

        let stage = AnyPipelineStageStub<[SourceCode]>()
        // Act

        try StubBuildCodeGeneratorPipelineFactory.build(
            templates: TestTemplates.swiftTemplateModels,
            specificationRootPath: homePath,
            astNodesToExclude: [],
            serviceName: "PackageSeparation",
            stage: stage.erase(),
            useNewNullableDefinitionStartegy: false
        ).run(with: specUrl)
        
        // Assert

        guard let sourceCodeModels = stage.result?.filter({
            $0.apiDefinitionFileRef.hasSuffix(SourceCode.separatedFilesSuffix)
        }) else {
            XCTFail("Test result models not found")
            return
        }
        for item in sourceCodeModels {
            if (homePath.isEmpty) {
                // destinationPath is not changed if the root is not set
                XCTAssertEqual(item.destinationPath, TestTemplates.testOutputPath)
            } else {
                let correctedPath = item.apiDefinitionFileRef
                    .dropFirst(homePath.count)
                    .dropLast(SourceCode.separatedFilesSuffix.count)
                XCTAssertEqual(
                    item.destinationPath,
                    "\(TestTemplates.testOutputPath)\(correctedPath)"
                )
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
