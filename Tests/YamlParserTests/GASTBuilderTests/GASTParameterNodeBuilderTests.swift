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

    func testParameters() {
        guard let updatePet = operations.first(where: { $0.identifier == "updatePetWithForm" }) else {
            XCTFail("Couldn't find operation for test")
            return
        }
        do {
            for parameter in updatePet.parameters {
                let node = try GASTParameterNodeBuilder().buildNode(for: parameter.value)

                guard case let .name(name) = node.subNodes[0].token else {
                    XCTFail("built node with incorrect token")
                    return
                }
                XCTAssert(parameter.value.name == name, "generated token is not of correct type")
                
                guard case let .type(type) = node.subNodes[1].token else {
                    XCTFail("built node with incorrect token")
                    return
                }
                XCTAssert(correctTypeForParameter(name: name) == type, "generated token is not of correct type")

                guard case let .location(location) = node.subNodes[2].token else {
                    XCTFail("built node with incorrect token")
                    return
                }
                XCTAssert(parameter.value.location.rawValue == location, "generated token is not of correct type")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func correctTypeForParameter(name: String) -> String {
        switch name {
        case "petId":
            return "Int"
        case "name":
            return "String"
        case "status":
            return "String"
        default:
            XCTFail("Couldn't check type for parameter with name: \(name)")
            return ""
        }
    }

}
