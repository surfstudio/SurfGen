//
//  TypeNodeParserTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class TypeNodeParserTests: XCTestCase {
    
    func testCorrectParsingForPlainType() {
        do {
            let type = try TypeNodeParser().detectType(for: Node(token: .type(name: "Int"), []))
            switch type {
            case .plain(let value):
                XCTAssert(value == "Int")
            default:
                XCTAssert(false, "Detected type is not expected one")
            }
        } catch {
            XCTAssert(false, "Parser shouldn't have thrown an error")
        }
    }

    func testCorrectParsingForObjectType() {
        do {
            let type = try TypeNodeParser().detectType(for: Node(token: .type(name: "object"), [Node(token: .type(name: "Child"), [])]))
            switch type {
            case .object(let value):
                XCTAssert(value == "Child")
            default:
                XCTAssert(false, "Detected type is not expected one")
            }
        } catch {
            XCTAssert(false, "Parser shouldn't have thrown an error")
        }
    }

    func testCorrectParsingForArrayOfObjectType() {
        do {
            let type = try TypeNodeParser().detectType(for: Node(token: .type(name: "array"),
                                                                 [Node(token: .type(name: "object"),
                                                                       [Node(token: .type(name: "Child"), [])])]))
            switch type {
            case .array(let type):
                if case let .object(value) = type {
                    XCTAssert(value == "Child")
                } else {
                    XCTAssert(false, "Detected type is not expected one")
                }
            default:
                XCTAssert(false, "Detected type is not expected one")
            }
        } catch {
            XCTAssert(false, "Parser shouldn't have thrown an error")
        }
    }

    func testCorrectParsingForArrayOfPlainType() {
        do {
            let type = try TypeNodeParser().detectType(for: Node(token: .type(name: "array"),
                                                                 [Node(token: .type(name: "Int"),
                                                                       [])]))
            switch type {
            case .array(let type):
                if case let .plain(value) = type {
                    XCTAssert(value == "Int")
                } else {
                    XCTAssert(false, "Detected type is not expected one")
                }
            default:
                XCTAssert(false, "Detected type is not expected one")
            }
        } catch {
            XCTAssert(false, "Parser shouldn't have thrown an error")
        }
    }

    func testNodeTokenError() {
        let errorTokens: [ASTToken] = [.root, .decl, .content, .name(value: ""), .field(isOptional: false)]
        for token in errorTokens {
            do {
                let _ = try TypeNodeParser().detectType(for: Node(token: token, []))
                XCTAssert(false, "Parser should have thrown an error")
            } catch {
                switch error as? GeneratorError {
                case .incorrectNodeToken:
                    XCTAssert(true)
                default:
                    XCTAssert(false, "TypeNodeParser error is not expected error")
                }
            }
        }
    }

    func testIncorrectSubNodesError() {
        do {
            let _ = try TypeNodeParser().detectType(for: Node(token: .type(name: "Int"),
                                                              [Node(token: .type(name: "String"), []), Node(token: .type(name: "Int"), [])]))
            XCTAssert(false, "Parser should have thrown an error")
        } catch {
            switch error as? GeneratorError {
            case .incorrectNodeNumber:
                XCTAssert(true)
            default:
                XCTAssert(false, "TypeNodeParser error is not expected error")
            }
        }
    }

}
