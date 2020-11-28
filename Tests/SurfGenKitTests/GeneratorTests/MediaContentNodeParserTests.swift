//
//  MediaContentNodeParserTests.swift
//  
//
//  Created by Dmitry Demyanov on 12.11.2020.
//

import XCTest
@testable import SurfGenKit

/// Tests for generating request/response body models from GAST mediaContent node
/// Perform checks if generated request/response body models match expected ones
class MediaContentNodeParserTests: XCTestCase {

    private let operationName = "testOperation"

    func testJsonEncodedModelRequestBodyParsing() throws {
        // given
        let requestContentNode = NodesBuilder.formRequestBodyNode(with: NodesBuilder.formJsonEncodedModelContentNode())
        let expectedRequestBody = RequestBodyGenerationModel.BodyType.model(.json, "Pet")
        
        // when
        let realRequestBody = try MediaContentNodeParser().parseRequestBody(node: requestContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realRequestBody, expectedRequestBody)
    }

    func testJsonEncodedArrayRequestBodyParsing() throws {
        // given
        let requestContentNode = NodesBuilder.formRequestBodyNode(with: NodesBuilder.formJsonEncodedArrayContentNode())
        let expectedRequestBody = RequestBodyGenerationModel.BodyType.array(.json, "Pet")
        
        // when
        let realRequestBody = try MediaContentNodeParser().parseRequestBody(node: requestContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realRequestBody, expectedRequestBody)
    }

    func testFormEncodedObjectRequestBodyParsing() throws {
        // given
        let requestContentNode = NodesBuilder.formRequestBodyNode(with: NodesBuilder.formFormEncodedObjectContentNode())
        let expectedRequestBody = RequestBodyGenerationModel.BodyType.dictionary(.form,
                                                                                 [
                                                                                    "testIntValue": "Int",
                                                                                    "testDoubleValue": "Double",
                                                                                    "testBoolValue": "Bool"
                                                                                 ]
        )
        
        // when
        let realRequestBody = try MediaContentNodeParser().parseRequestBody(node: requestContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realRequestBody, expectedRequestBody)
    }

    func testMultipartModelRequestBodyParsing() throws {
        // given
        let requestContentNode = NodesBuilder.formRequestBodyNode(with: NodesBuilder.formMultipartModelContentNode())
        let expectedRequestBody = RequestBodyGenerationModel.BodyType.multipartModel
        
        // when
        let realRequestBody = try MediaContentNodeParser().parseRequestBody(node: requestContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realRequestBody, expectedRequestBody)
    }

    func testUnsupportedEncodingRequestBodyParsing() throws {
        // given
        let requestContentNode = NodesBuilder.formRequestBodyNode(with: NodesBuilder.formUnsupportedEncodingContentNode())
        let expectedRequestBody = RequestBodyGenerationModel.BodyType.unsupportedEncoding("testEncoding")
        
        // when
        let realRequestBody = try MediaContentNodeParser().parseRequestBody(node: requestContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realRequestBody, expectedRequestBody)
    }

    func testModelResponseBodyParsing() throws {
        // given
        let responseContentNode = NodesBuilder.formResponseBodyNode(with: NodesBuilder.formJsonEncodedModelContentNode())
        let expectedResponseBody = ResponseBody.model("Pet")
        
        // when
        let realResponseBody = try MediaContentNodeParser().parseResponseBody(node: responseContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realResponseBody, expectedResponseBody)
    }

    func testArrayResponseBodyParsing() throws {
        // given
        let responseContentNode = NodesBuilder.formResponseBodyNode(with: NodesBuilder.formJsonEncodedArrayContentNode())
        let expectedResponseBody = ResponseBody.arrayOf("Pet")
        
        // when
        let realResponseBody = try MediaContentNodeParser().parseResponseBody(node: responseContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realResponseBody, expectedResponseBody)
    }

    func testComplexObjectResponseBodyParsing() throws {
        // given
        let responseContentNode = NodesBuilder.formResponseBodyNode(with: NodesBuilder.formFormEncodedObjectContentNode())
        let expectedResponseBody = ResponseBody.unsupportedObject
        
        // when
        let realResponseBody = try MediaContentNodeParser().parseResponseBody(node: responseContentNode, forOperationName: operationName)
        
        // then
        XCTAssertEqual(realResponseBody, expectedResponseBody)
    }

}
