//
//  GASTOperationNodeBuilderTests.swift
//  
//
//  Created by Dmitry Demyanov on 28.10.2020.
//

import XCTest
@testable import YamlParser
import Swagger
import SurfGenKit

/// Tests for building operation node and its content
class GASTOperationNodeBuilderTests: XCTestCase {

    var operations: [Swagger.Operation]!

    override func setUp() {
        do {
            operations = try SwaggerSpec(string: FileReader().readFile("TestFiles/petstore.yaml")).operations
                .filter { $0.path.starts(with: "/pet") && !$0.deprecated }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func testGetPetOperationNodeMatchesExpected() throws {
        guard let getPet = operations.first(where: { $0.identifier == "getPetById" }) else {
            XCTFail("Couldn't find operation for test")
            return
        }
        let node = try GASTOperationNodeBuilder().buildMethodNode(for: getPet)
        
        guard case let .type(method) = node.subNodes[0].token else {
            XCTFail("Built type node with incorrect token")
            return
        }
        XCTAssert("get" == method, "Generated method token is not of correct type")

        guard case let .path(path) = node.subNodes[1].token else {
            XCTFail("Built path node with incorrect token")
            return
        }
        XCTAssert("/pet/{petId}" == path, "Generated path token is not of correct type")

        guard case let .name(name) = node.subNodes[2].token else {
            XCTFail("Built name node with incorrect token")
            return
        }
        XCTAssert("getPetById" == name, "Generated name token is not of correct type")

        guard case let .description(description) = node.subNodes[3].token else {
            XCTFail("Built description node with incorrect token")
            return
        }
        XCTAssert("Find pet by ID" == description, "Generated description token is not of correct type")

        guard node.subNodes[4].token == .parameters else {
            XCTFail("Built parameters node with incorrect token")
            return
        }

        guard node.subNodes[5].token == .responseBody else {
            XCTFail("Built responseBody node with incorrect token")
            return
        }
    }

    func testAddPetOperationNodeMatchesExpected() throws {
        // given
        guard let postPet = operations.first(where: { $0.identifier == "addPet" }) else {
            XCTFail("Couldn't find operation for test")
            return
        }
        // when
        let node = try GASTOperationNodeBuilder().buildMethodNode(for: postPet)

        // then
        guard case let .type(method) = node.subNodes[0].token else {
            XCTFail("Built method node with incorrect token")
            return
        }
        XCTAssert("post" == method, "Generated method token is not of correct type")

        guard case let .path(path) = node.subNodes[1].token else {
            XCTFail("Built path node with incorrect token")
            return
        }
        XCTAssert("/pet" == path, "Generated path token is not of correct type")

        guard case let .name(name) = node.subNodes[2].token else {
            XCTFail("Built name node with incorrect token")
            return
        }
        XCTAssert("addPet" == name, "Generated name token is not of correct type")

        guard case let .description(description) = node.subNodes[3].token else {
            XCTFail("Built description node with incorrect token")
            return
        }
        XCTAssert("Add a new pet to the store" == description, "Generated description token is not of correct type")

        guard case let .requestBody(isRequestBodyOptional) = node.subNodes[4].token else {
            XCTFail("Built requestBody node with incorrect token")
            return
        }
        XCTAssert(false == isRequestBodyOptional, "Generated requestBody token is not of correct type")

        guard node.subNodes[5].token == .responseBody else {
            XCTFail("Built responseBody node with incorrect token")
            return
        }
    }

}
