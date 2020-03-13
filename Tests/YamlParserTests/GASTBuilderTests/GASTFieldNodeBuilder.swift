//
//  GASTFieldNodeBuilder.swift
//  SurfGen
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import XCTest
@testable import YamlParser
import Swagger
import SurfGenKit

class GASTFieldNodeBuilderTests: XCTestCase {

    var schemas: [ComponentObject<Schema>]!
    var orderObject: ObjectSchema!

    override func setUp() {
        do {
            schemas = try SwaggerSpec(string: FileReader().readFile("TestFiles/rendezvous.yaml")).components.schemas
            orderObject = schemas.first(where: { $0.name == "Order" })?.value.type.object!
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func testPlainType() {
        // test plain types
        guard
            let canceledProperty = orderObject.properties.first(where: { $0.name == "can_be_canceled" })?.schema.type,
            let nameProperty = orderObject.properties.first(where: { $0.name == "name" })?.schema.type else {
                XCTFail("Error while loading models")
                return
        }

        do {
            let canceledPropertyNode = try GASTFieldNodeBuilder().buildFieldType(for: canceledProperty)
            let namePropertyNode = try GASTFieldNodeBuilder().buildFieldType(for: nameProperty)
            guard
                case let .type(cancelType) = canceledPropertyNode.token,
                case let .type(nameType) = namePropertyNode.token else {
                    XCTFail("built node with incorrect token")
                    return
            }

            XCTAssert("String" == nameType, "generated token is not of correct type")
            XCTAssert("Bool" == cancelType, "generated token is not of correct type")
            XCTAssert(canceledPropertyNode.subNodes.isEmpty, "generated subnodes is not equal to expected ones")
            XCTAssert(namePropertyNode.subNodes.isEmpty, "generated subnodes is not equal to expected ones")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRefType() {
        complexNodeTest(propertyName: "recipient", expectedNodeType: "object", expectedSubNodeType: "OrderRecipient")
    }

    func testArrayType() {
        complexNodeTest(propertyName: "products", expectedNodeType: "array", expectedSubNodeType: "object", expectedSubSubNodeType: "OrderBoughtProduct")
    }

    func complexNodeTest(propertyName: String, expectedNodeType: String, expectedSubNodeType: String, expectedSubSubNodeType: String? = nil) {
        guard let recipientSchema = orderObject.properties.first(where: { $0.name == propertyName })?.schema.type else {
            XCTFail("Error while loading model")
            return
        }

        do {
            let builtNode = try GASTFieldNodeBuilder().buildFieldType(for: recipientSchema)

            guard case let .type(typeName) = builtNode.token else {
                XCTFail("built node with incorrect token")
                return
            }

            XCTAssert(expectedNodeType == typeName, "generated token is not of correct type")
            XCTAssert(builtNode.subNodes.count == 1, "generated subnodes is not equal to expected ones")

            guard case let .type(subTypeName) = builtNode.subNodes[0].token else {
                XCTFail("built node with incorrect subnode token")
                return
            }

            XCTAssert(expectedSubNodeType == subTypeName, "generated token is not of correct type")
            XCTAssert(builtNode.subNodes[0].subNodes.count == (expectedSubSubNodeType == nil ? 0 : 1), "generated subnodes is not equal to expected ones")

            guard let extectedSubSubNode = expectedSubSubNodeType else {
                return
            }

            guard case let .type(subSubTypeNode) = builtNode.subNodes[0].subNodes[0].token else {
                XCTFail("built node with incorrect subnode token")
                return
            }

            XCTAssert(extectedSubSubNode == subSubTypeNode, "generated token is not of correct type")
            XCTAssert(builtNode.subNodes[0].subNodes[0].subNodes.isEmpty, "generated subnodes is not equal to expected ones")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testErrorCases() {
        guard let shop = schemas.first(where: { $0.name == "ShopWithProduct" }) else {
            XCTFail("Error while loading model")
            return
        }
        assertThrow(try GASTFieldNodeBuilder().buildFieldType(for: shop.value.type), throws: GASTBuilderError.undefinedTypeForField(""))

        assertThrow(try GASTFieldNodeBuilder().buildFieldType(for: .any), throws: GASTBuilderError.undefinedTypeForField(""))
    }

}
