//
//  GASTMediaContentNodeBuilderTests.swift
//  
//
//  Created by Dmitry Demianov on 29.10.2020.
//

import XCTest
@testable import YamlParser
import Swagger
import SurfGenKit

class GASTMediaContentNodeBuilderTests: XCTestCase {

    var operations: [Swagger.Operation]!

    override func setUp() {
        do {
            operations = try SwaggerSpec(string: FileReader().readFile("TestFiles/petstore.yaml")).operations
                .filter { $0.path.starts(with: "/pet") && !$0.deprecated }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func testRequestBodyContent() {
        guard
            let postPet = operations.first(where: { $0.identifier == "addPet" }),
            let requestBody = postPet.requestBody?.value.content
        else {
            XCTFail("Couldn't find operation for test")
            return
        }
        do {
            let node = try GASTMediaContentNodeBuilder().buildMediaContentNode(with: requestBody)

            guard case let .encoding(encoding) = node.subNodes[0].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("application/json" == encoding, "generated token is not of correct type")

            guard case let .type(bodyType) = node.subNodes[1].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("Pet" == bodyType, "generated token is not of correct type")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testResponseBodyContent() {
        guard
            let postPet = operations.first(where: { $0.identifier == "getPetById" }),
            let responseBody = postPet.responses.filter({ $0.statusCode == 200 }).first?.response.value.content
        else {
            XCTFail("Couldn't find operation for test")
            return
        }
        do {
            let node = try GASTMediaContentNodeBuilder().buildMediaContentNode(with: responseBody)

            guard case let .encoding(encoding) = node.subNodes[0].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("application/json" == encoding, "generated token is not of correct type")

            guard case let .type(bodyType) = node.subNodes[1].token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert("Pet" == bodyType, "generated token is not of correct type")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
