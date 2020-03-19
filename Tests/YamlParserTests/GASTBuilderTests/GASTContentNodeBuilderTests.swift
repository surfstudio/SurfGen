//
//  GASTContentNodeBuilderTests.swift
//  YamlParserTests
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import XCTest
@testable import YamlParser
import Swagger
import SurfGenKit

class GASTContentNodeBuilderTests: XCTestCase {

    var schemas: [ComponentObject<Schema>]!

    // MARK: - Constants

    private enum Constants {
        static let plainObjects = ["Order": 10, "OrderBoughtProduct": 2, "OrderPriceInfo": 3]
    }

    override func setUp() {
        do {
            schemas = try SwaggerSpec(string: FileReader().readFile("TestFiles/rendezvous.yaml")).components.schemas
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func testContentNodeBuilder() {
        Constants.plainObjects.forEach { key, value in
            plainObjectTest((schemas.first(where: { $0.name == key })?.value.type.object!)!, numberOfProperties: value)
        }
    }

    func plainObjectTest(_ object: ObjectSchema, numberOfProperties: Int) {
        let builder = GASTContentNodeBuilder()
        do {
            let node = try builder.buildObjectContentSubnodes(for: object)
            guard case .content = node.token else {
                XCTFail("built node with incorrect token")
                return
            }
            XCTAssert(node.subNodes.count == numberOfProperties, "incorrent number of subnodes")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
