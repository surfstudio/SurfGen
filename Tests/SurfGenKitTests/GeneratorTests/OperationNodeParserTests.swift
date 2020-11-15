//
//  OperationNodeParserTests.swift
//  
//
//  Created by Dmitry Demyanov on 12.11.2020.
//

import XCTest
@testable import SurfGenKit

/// Tests for generating operation model from GAST tree
/// Perform checks if all parts of generated operation match expected ones
class OperationNodeParserTests: XCTestCase {

    private enum Constants {
        static let testServiceName = "Pet"
    }

    func testPostOperationMethodParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formPostPetByIdOperationNode()
        let expectedMethod = "post"
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.httpMethod, expectedMethod)
    }

    func testGetOperationMethodParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formFindPetByStatusOperationNode()
        let expectedMethod = "get"
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.httpMethod, expectedMethod)
    }

    func testOperationNameParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formPostPetByIdOperationNode()
        let expectedName = "postPetPetId"
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.name, expectedName)
    }

    func testOperationDescriptionParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formFindPetByStatusOperationNode()
        let expectedDescription = "Finds Pets by status"
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.description, expectedDescription)
    }

    func testPostOperationPathParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formPostPetByIdOperationNode()

        let expectedPathName = "petPetId"
        let expectedPathString = "/pet/\\(petId)"
        let expectedPathHasParameters = true
        let expectedPathParameters = ["petId"]
        
        // when
        let generatedPathModel = try OperationNodeParser().parsePath(from: operation)
        
        // then
        XCTAssertEqual(generatedPathModel.name, expectedPathName)
        XCTAssertEqual(generatedPathModel.path, expectedPathString)
        XCTAssertEqual(generatedPathModel.hasParameters, expectedPathHasParameters)
        XCTAssertEqual(generatedPathModel.parameters, expectedPathParameters)
    }

    func testGetOperationPathParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formFindPetByStatusOperationNode()

        let expectedPathName = "findByStatus"
        let expectedPathString = "/pet/findByStatus"
        let expectedPathHasParameters = false
        let expectedPathParameters = [String]()
        
        // when
        let generatedPathModel = try OperationNodeParser().parsePath(from: operation)
        
        // then
        XCTAssertEqual(generatedPathModel.name, expectedPathName)
        XCTAssertEqual(generatedPathModel.path, expectedPathString)
        XCTAssertEqual(generatedPathModel.hasParameters, expectedPathHasParameters)
        XCTAssertEqual(generatedPathModel.parameters, expectedPathParameters)
    }

    func testOperationQueryParametersParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formFindPetByStatusOperationNode()

        let expectedParameters = [ParameterGenerationModel(name: "status",
                                                           serverName: "status",
                                                           type: "String",
                                                           isOptional: false,
                                                           location: .query)]
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.queryParameters, expectedParameters)
    }

    func testOperationModelRequestBodyParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formPostPetByIdOperationNode()

        let expectedHasBody = true
        let expectedHasFormEncoding = false
        let expectedHasUnsupportedEncoding = false
        let expectedisBodyModel = true
        let expectedIsBodyArray = false
        let expectedBodyModelName = "pet"
        let expectedBodyModelType = "PetEntity"
        let expectedIsBodyDictionary = false
        
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.hasBody, expectedHasBody)
        XCTAssertEqual(generatedOperation.hasFormEncoding, expectedHasFormEncoding)
        XCTAssertEqual(generatedOperation.hasUnsupportedEncoding, expectedHasUnsupportedEncoding)
        XCTAssertEqual(generatedOperation.isBodyModel, expectedisBodyModel)
        XCTAssertEqual(generatedOperation.isBodyArray, expectedIsBodyArray)
        XCTAssertEqual(generatedOperation.bodyModelName, expectedBodyModelName)
        XCTAssertEqual(generatedOperation.bodyModelType, expectedBodyModelType)
        XCTAssertEqual(generatedOperation.isBodyDictionary, expectedIsBodyDictionary)
    }

    func testOperationDictionaryRequestBodyParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formFindPetByStatusOperationNode()

        let expectedHasBody = true
        let expectedHasFormEncoding = true
        let expectedHasUnsupportedEncoding = false
        let expectedisBodyModel = false
        let expectedIsBodyArray = false
        let expectedIsBodyDictionary = true
        let expectedBodyParameters = [
            ParameterGenerationModel(name: "testBoolValue",
                                     serverName: "testBoolValue",
                                     type: "Bool",
                                     isOptional: false,
                                     location: .body),
            ParameterGenerationModel(name: "testDoubleValue",
                                     serverName: "testDoubleValue",
                                     type: "Double",
                                     isOptional: false,
                                     location: .body),
            ParameterGenerationModel(name: "testIntValue",
                                     serverName: "testIntValue",
                                     type: "Int",
                                     isOptional: false,
                                     location: .body)
        ]
        
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.hasBody, expectedHasBody)
        XCTAssertEqual(generatedOperation.hasFormEncoding, expectedHasFormEncoding)
        XCTAssertEqual(generatedOperation.hasUnsupportedEncoding, expectedHasUnsupportedEncoding)
        XCTAssertEqual(generatedOperation.isBodyModel, expectedisBodyModel)
        XCTAssertEqual(generatedOperation.isBodyArray, expectedIsBodyArray)
        XCTAssertEqual(generatedOperation.isBodyDictionary, expectedIsBodyDictionary)
        XCTAssertEqual(generatedOperation.bodyParameters, expectedBodyParameters)
    }

    func testOperationModelResponseBodyParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formPostPetByIdOperationNode()

        let expectedHasUndefinedRedponseBody = false
        let expectedResponseModel = "Void"
        
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.hasUndefinedResponseBody, expectedHasUndefinedRedponseBody)
        XCTAssertEqual(generatedOperation.responseModel, expectedResponseModel)
    }

    func testOperationArrauResponseBodyParsingMatchesExpected() throws {
        // given
        let operation = NodesBuilder.formFindPetByStatusOperationNode()

        let expectedHasUndefinedRedponseBody = false
        let expectedResponseModel = "[PetEntity]"
        
        
        // when
        let generatedOperation = try OperationNodeParser().parse(operation: operation,
                                                                 forServiceName: Constants.testServiceName)
        
        // then
        XCTAssertEqual(generatedOperation.hasUndefinedResponseBody, expectedHasUndefinedRedponseBody)
        XCTAssertEqual(generatedOperation.responseModel, expectedResponseModel)
    }

}
