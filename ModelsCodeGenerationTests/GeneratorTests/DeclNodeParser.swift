//
//  DeclNodeParser.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 04/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class DeclNodeParserTests: XCTestCase {

    func testSubnodesError() {
        let declNode = Node(token: .decl,
                            [
                                Node(token: .type(name: ""), []),
                                Node(token: .name(value: "ShopLocation"), []),
                                Node(token: .content, [ formFieldNode(isOptional: false, name: "region", typeName: "String") ])
                            ])
        
        do {
            let _ = try DeclNodeParser.getInfo(from: declNode)
            XCTAssert(false, "Decl error was not recognized")
        } catch {
            switch error as? GeneratorError {
            case .incorrectNodeNumber:
                XCTAssert(true)
            default:
                XCTAssert(false, "Decl error is not expected error")
            }
        }
    }

    func testNameNodeError() {
        let declNode = Node(token: .decl,
                            [
                                Node(token: .type(name: ""), []),
                                Node(token: .content, [ formFieldNode(isOptional: false, name: "region", typeName: "String") ])
                            ])
        
        do {
            let _ = try DeclNodeParser.getInfo(from: declNode)
            XCTAssert(false, "Decl error was not recognized")
        } catch {
            switch error as? GeneratorError {
            case .nodeConfiguration:
                XCTAssert(true)
            default:
                XCTAssert(false, "Decl error is not expected error")
            }
        }
    }

    func testContentNodeError() {
        let declNode = Node(token: .decl,
                            [
                                Node(token: .name(value: "ShopLocation"), []),
                                formFieldNode(isOptional: false, name: "region", typeName: "String")
                            ])
        
        do {
            let _ = try DeclNodeParser.getInfo(from: declNode)
            XCTAssert(false, "Decl error was not recognized")
        } catch {
            switch error as? GeneratorError {
            case .nodeConfiguration:
                XCTAssert(true)
            default:
                XCTAssert(false, "Decl error is not expected error")
            }
        }
    }

}
