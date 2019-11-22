//
//  DeclGeneratorTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class DeclGeneratorTests: XCTestCase {

    func testDeclEntityCodeGenerator() {
        let declNode = Node(token: .decl, [Node(token: .name(value: "Login"), [])])

        let expectedCode = "public struct LoginEntity {"
        let generatedCode = try? DeclGenerator().generateCode(for: declNode, type: .entity)
        XCTAssert(expectedCode == generatedCode)
    }

    func testDeclEntryCodeGenerator() {
        let declNode = Node(token: .decl, [Node(token: .name(value: "Login"), [])])

        let expectedCode = "public struct LoginEntry: Codable {"
        let generatedCode = try? DeclGenerator().generateCode(for: declNode, type: .entry)
        XCTAssert(expectedCode == generatedCode)
    }
    

}
