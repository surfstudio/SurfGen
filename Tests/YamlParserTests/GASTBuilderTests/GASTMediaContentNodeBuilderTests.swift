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

/// Tests for building operation request/response body node
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

    /// Checks if request content node for operation `addPet` matches expected
    func testRequestBodyContentNodeMatchesExpected() throws {
        // given
        guard
            let postPet = operations.first(where: { $0.identifier == "addPet" }),
            let requestBody = postPet.requestBody?.value.content
        else {
            XCTFail("Couldn't find operation for test")
            return
        }

        // when
        let node = try GASTMediaContentNodeBuilder().buildMediaContentNode(with: requestBody)

        // then
        guard case let .encoding(encoding) = node.subNodes[0].token else {
            XCTFail("Encoding subnode has incorrect token")
            return
        }
        XCTAssert("application/json" == encoding, "Generated encoding token is not of correct type")

        guard case let .type(bodyType) = node.subNodes[1].token else {
            XCTFail("Type subnode has incorrect token")
            return
        }
        XCTAssert("Pet" == bodyType, "Generated type token is not of correct type")
    }

    /// Checks if response content node for operation `getPetById` matches expected
    func testResponseBodyContentNodeMatchesExpected() throws {
        // given
        guard
            let postPet = operations.first(where: { $0.identifier == "getPetById" }),
            let responseBody = postPet.responses.filter({ $0.statusCode == 200 }).first?.response.value.content
        else {
            XCTFail("Couldn't find operation for test")
            return
        }

        // when
        let node = try GASTMediaContentNodeBuilder().buildMediaContentNode(with: responseBody)

        // then
        guard case let .encoding(encoding) = node.subNodes[0].token else {
            XCTFail("Encoding subnode has incorrect token")
            return
        }
        XCTAssert("application/json" == encoding, "Generated encoding token is not of correct type")

        guard case let .type(bodyType) = node.subNodes[1].token else {
            XCTFail("Type subnode has incorrect token")
            return
        }
        XCTAssert("Pet" == bodyType, "Generated type token is not of correct type")
    }

}
