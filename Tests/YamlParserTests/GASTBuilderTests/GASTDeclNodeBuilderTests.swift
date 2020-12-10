//
//  GASTDeclNodeBuilderTests.swift
//  SurfGen
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import XCTest
@testable import YamlParser
import Swagger
import SurfGenKit

/// Tests for building object, enum and service decl nodes
class GASTDeclNodeBuilderTests: XCTestCase {

    let declNodeBuilder = GASTDeclNodeBuilder(contentNodeBuilder: GASTContentNodeBuilder())

    var shopObject: ComponentObject<Schema>!
    var deleveryEnumObject: ComponentObject<Schema>!
    var operations: [Swagger.Operation]!

    // MARK: - Constants

    override func setUp() {
        do {
            let spec = try SwaggerSpec(string: FileReader().readFile("TestFiles/rendezvous.yaml"))
            shopObject = spec.components.schemas.first(where: { $0.name == "ShopLocation" })!
            deleveryEnumObject = spec.components.schemas.first(where: { $0.name == "DeliveryType" })!

            operations = spec.operations.filter { $0.path.starts(with: "/pet") && !$0.deprecated }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    // Checks if built decl node for model has correct token, name and content subnodes
    func testDeclNodeMatchesExpected() throws {
        // when
        let node = try declNodeBuilder.buildDeclNode(for: shopObject)

        // then

        // check for correct node token
        guard case .decl = node.token else {
            XCTFail("decl node has incorrect token")
            return
        }

        // check subnodes

        guard case let .name(value) = node.subNodes[0].token else {
            XCTFail("decl name subnode has incorrect token")
            return
        }

        XCTAssert(value == "ShopLocation", "Name subnode is incorrect")

        guard case .content = node.subNodes[1].token else {
            XCTFail("decl content subnode has incorrect token")
            return
        }
    }

    // Checks if built decl node for enum has correct token, name and content subnodes
    func testEnumDeclNodeMatchesExpected() throws {
        // when
        let node = try declNodeBuilder.buildDeclNode(for: deleveryEnumObject)

        // then

        // check for correct node token
        guard case .decl = node.token else {
            XCTFail("decl node has incorrect token")
            return
        }

        // check subnodes

        guard case let .name(value) = node.subNodes[0].token else {
            XCTFail("decl name subnode has incorrect token")
            return
        }

        XCTAssert(value == "DeliveryType", "Name subnode is incorrect")

        guard case .content = node.subNodes[1].token else {
            XCTFail("decl content subnode has incorrect token")
            return
        }
    }

    // Checks if built decl node for service has correct token, name and content subnodes
    func testServiceDeclNodeMatchesExpected() throws {
        // when
        let node = try declNodeBuilder.buildDeclNode(forRootPath: "Pet", with: operations)

        //then
        
        // check for correct node token
        guard case .decl = node.token else {
            XCTFail("decl node has incorrect token")
            return
        }

        // check subnodes
        guard case let .name(value) = node.subNodes[0].token else {
            XCTFail("decl name subnode has incorrect token")
            return
        }

        XCTAssert(value == "Pet", "Name subnode is incorrect")

        guard case .content = node.subNodes[1].token else {
            XCTFail("decl content subnode has incorrect token")
            return
        }
    }

}
