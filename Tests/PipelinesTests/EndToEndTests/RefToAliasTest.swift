//
//  RefToAliasTest.swift
//  
//
//  Created by volodina on 18.02.2022.
//

import Foundation

import Foundation
import Pipelines
import XCTest
import UtilsForTesting
import CodeGenerator
import Common

/// Test api is defined in Tests/Common/RefToAlias
/// The idea is to check `typeModel` output for an array as an example which is defined in two ways:
/// ref to array alias (/polygons endpoint) or usual array definition as an object (/coordinates endpoint)
class RefToAliasTest : XCTestCase {
    
    /// Test ref to alias support in specification
    func testTypeModelForRefToAliasIsCorrect() throws {
        // Arrange
        
        let testOperation = try getRefToAliasTestOperation(operation: "/polygons")!

        // Assert
  
        // RequestModel for /polygons
        testRefToAliasDataModel(dataModel: testOperation.requestModel!.value.content.first!)
        
        // ResponseModel for /polygons
        testRefToAliasDataModel(dataModel: testOperation.responses!.first!.value.values.first!)
    }
    
    func testTypeModelForArrayIsCorrect() throws {
        // Arrange
        
        let testOperation = try getRefToAliasTestOperation(operation: "/coordinates")!
        
        // Assert

        // RequestModel for /coordinates
        testObjectDataModel(dataModel: testOperation.requestModel!.value.content.first!)
        
        // ResponseModel for /coordinates
        testObjectDataModel(dataModel: testOperation.responses!.first!.value.values.first!)
    }
    
    private func getRefToAliasTestOperation(operation: String) throws -> OperationModel? {
        let testedApiUrl = "api.yaml"
        let homeUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/RefToAlias")
        let specUrl = homeUrl.appendingPathComponent(testedApiUrl)

        let stage = AnyPipelineStageStub<[[PathModel]]>()
        // Act

        try StubBuildCodeGeneratorPipelineFactory.build(
            templates: [],
            astNodesToExclude: [],
            serviceName: "RefToAlias",
            stage: stage.erase(),
            useNewNullableDefinitionStartegy: false
        ).run(with: specUrl)
        
        // PathModel for operation
        guard let testPath = stage.result!.last!.first(where: { path in path.path == operation }) else {
            XCTFail("Test api path not found")
            return nil
        }
        // OperationModel operation
        guard let testOperation = testPath.operations.first else {
            XCTFail("Tested operation not found")
            return nil
        }
        
        return testOperation
    }
    
    private func testRefToAliasDataModel(dataModel: DataModel) {
        guard case DataModel.PossibleType.array(let arrayDataModel) = dataModel.type else {
            XCTFail("Error while arrayDataModel casting")
            return
        }
        guard case SchemaArrayModel.PossibleType.reference(let itemsType) = arrayDataModel.itemsType else {
            XCTFail("Error while itemsType casting")
            return
        }
        guard case SchemaType.object(let objectModel) = itemsType else {
            XCTFail("Error while objectModel casting")
            return
        }
        guard let testedProperty = objectModel.properties.first else {
            XCTFail("testedProperty not found")
            return
        }
        testTypeModel(typeModel: testedProperty.typeModel)
    }
    
    private func testObjectDataModel(dataModel: DataModel) {
        guard case DataModel.PossibleType.object(let objectDataModel) = dataModel.type else {
            XCTFail("Error while objectDataModel casting")
            return
        }
        guard let typeModel = objectDataModel.properties.first?.typeModel else {
            XCTFail("Error while typeModel casting")
            return
        }
        testTypeModel(typeModel: typeModel)
    }
    
    private func testTypeModel(typeModel: ItemTypeModel) {
        XCTAssertEqual(typeModel.name, "Coords")
        XCTAssertEqual(typeModel.isArray, true)
        XCTAssertEqual(typeModel.isObject, true)
    }
}
