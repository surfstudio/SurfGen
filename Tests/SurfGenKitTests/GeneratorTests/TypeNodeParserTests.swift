//
//  TypeNodeParserTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import SurfGenKit

class TypeNodeParserTests: XCTestCase {

    private let parser = TypeNodeParser(platform: .swift)

    func formParserAndGetType(for node: Node) -> Type {

        var type: Type? = nil

        XCTAssertNoThrow(type = try parser.detectType(for: node))

        guard let resultType = type else {
            preconditionFailure("No type was generated")
        }

        return resultType
    }

    func testCorrectParsingForPlainType() {

        let type = formParserAndGetType(for: Node(token: .type(name: "integer"), []))

        guard case let .plain(value) = type else {
            XCTFail("Detected type is not expected one")
            return
        }

        XCTAssertEqual(value, "Int")
    }

    func testCorrectParsingForObjectType() {

        let type = formParserAndGetType(for: Node(token: .type(name: ASTConstants.object), [Node(token: .type(name: "Child"), [])]))

        guard case let .object(value) = type else {
            XCTFail("Detected type is not expected one")
            return
        }

        XCTAssertEqual(value, "Child")
    }

    func testCorrectParsingForArrayOfObjectType() {
        let node = Node(token: .type(name: "array"),
                         [Node(token: .type(name: "object"),
                               [Node(token: .type(name: "Child"), [])])])
        let type = formParserAndGetType(for: node)

        guard case let .array(arrType) = type, case let .object(value) = arrType else {
            XCTFail("Detected type is not expected one")
            return
        }

        XCTAssertEqual(value, "Child")
    }

    func testCorrectParsingForArrayOfPlainType() {
        let node = Node(token: .type(name: "array"),
                        [Node(token: .type(name: "integer"),
                              [])])
        let type = formParserAndGetType(for: node)

        guard case let .array(arrType) = type, case let .plain(value) = arrType else {
            XCTFail("Detected type is not expected one")
            return
        }

        XCTAssertEqual(value, "Int")
    }
    
    func testIncorrectTypes() {
        let node = Node(token: .type(name: "Int"),
                        [Node(token: .type(name: "String"), [])])
        assertThrow(try parser.detectType(for: node), throws: GeneratorError.nodeConfiguration(""))
    }

    func testNodeTokenError() {
        let errorTokens: [ASTToken] = [.root, .decl, .content, .name(value: ""), .field(isOptional: false)]
        for token in errorTokens {
            assertThrow(try parser.detectType(for: Node(token: token, [])), throws: GeneratorError.incorrectNodeToken(""))
        }
    }

    func testIncorrectSubNodesError() {
        let node = Node(token: .type(name: "Int"),
                        [Node(token: .type(name: "String"), []), Node(token: .type(name: "Int"), [])])
        assertThrow(try parser.detectType(for: node), throws: GeneratorError.incorrectNodeNumber(""))
    }

}
