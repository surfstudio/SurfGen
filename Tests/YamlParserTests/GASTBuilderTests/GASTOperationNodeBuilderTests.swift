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

    func testGetMethod() {
        guard let getPet = operations.first(where: { $0.identifier == "getPetById" }) else {
            XCTFail("Couldn't find operation for test")
            return
        }
        do {
            let node = try GASTOperationNodeBuilder().buildMethodNode(for: getPet)
            
            guard case let .type(method) = node.subNodes[0].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("get" == method, "generated token is not of correct type")

            guard case let .path(path) = node.subNodes[1].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("/pet/{petId}" == path, "generated token is not of correct type")

            guard case let .name(name) = node.subNodes[2].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("getPetById" == name, "generated token is not of correct type")

            guard case let .description(description) = node.subNodes[3].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("Find pet by ID" == description, "generated token is not of correct type")

            guard node.subNodes[4].token == .parameters else {
                XCTFail("built node with incorrect token")
                return
            }

            guard node.subNodes[5].token == .responseBody else {
                XCTFail("built node with incorrect token")
                return
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPostMethod() {
        guard let postPet = operations.first(where: { $0.identifier == "addPet" }) else {
            XCTFail("Couldn't find operation for test")
            return
        }
        do {
            let node = try GASTOperationNodeBuilder().buildMethodNode(for: postPet)
            
            guard case let .type(method) = node.subNodes[0].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("post" == method, "generated token is not of correct type")

            guard case let .path(path) = node.subNodes[1].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("/pet" == path, "generated token is not of correct type")

            guard case let .name(name) = node.subNodes[2].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("addPet" == name, "generated token is not of correct type")

            guard case let .description(description) = node.subNodes[3].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("Add a new pet to the store" == description, "generated token is not of correct type")

            guard case let .requestBody(isRequestBodyOptional) = node.subNodes[4].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert(false == isRequestBodyOptional, "generated token is not of correct type")

            guard node.subNodes[5].token == .responseBody else {
                XCTFail("built node with incorrect token")
                return
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
