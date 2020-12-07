//
//  GASTParameterNodeBuilderTests.swift
//  
//
//  Created by Dmitry Demyanov on 29.10.2020.
//

import XCTest
@testable import YamlParser
import Swagger
import SurfGenKit

class GASTParameterNodeBuilderTests: XCTestCase {

    var operations: [Swagger.Operation]!

    override func setUp() {
        do {
            operations = try SwaggerSpec(string: FileReader().readFile("TestFiles/petstore.yaml")).operations
                .filter { $0.path.starts(with: "/pet") && !$0.deprecated }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    /// Checks if parameter nodes for operation `updatePetWithForm` are built as expected
    func testUpdatePetParameterNodesMatchExpected() throws {
        // given
        guard let updatePet = operations.first(where: { $0.identifier == "updatePetWithForm" }) else {
            XCTFail("Couldn't find operation for test")
            return
        }

        // when
        for parameter in updatePet.parameters {
            let node = try GASTParameterNodeBuilder().buildNode(for: parameter.value)

            // then
            guard case let .name(name) = node.subNodes[0].token else {
                XCTFail("Built name node with incorrect token")
                return
            }
            XCTAssert(parameter.value.name == name, "Generated name token is not of correct type")

            guard case let .type(type) = node.subNodes[1].token else {
                XCTFail("Built type node with incorrect token")
                return
            }
            XCTAssert(correctTypeForParameter(name: name) == type, "Generated type token is not of correct type")

            guard case let .location(location) = node.subNodes[2].token else {
                XCTFail("Built location node with incorrect token")
                return
            }
            XCTAssert(parameter.value.location.rawValue == location, "Generated location token is not of correct type")
        }
    }

    func correctTypeForParameter(name: String) -> String {
        switch name {
        case "petId":
            return "Int"
        case "name", "status":
            return "String"
        default:
            XCTFail("Couldn't check type for parameter with name: \(name)")
            return ""
        }
    }

}
