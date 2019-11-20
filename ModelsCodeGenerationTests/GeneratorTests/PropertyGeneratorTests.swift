//
//  PropertyGeneratorTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class PropertyGeneratorTests: XCTestCase {
    
    func testStandardOptionalFieldCodeGeneration() {
        let fieldNode = formFieldNode(isOptional: true, name: "login", typeName: "String")
        let expectedCode = "public let login: String?"
        let generatedCode = try? PropertyGenerator().generateCode(for: fieldNode, type: .entity)
        XCTAssert(expectedCode == generatedCode)
    }
    
    func testCustomOptionalFieldCodeGeneration() {
        let fieldNode = formFieldNode(isOptional: true, name: "info", typeName: "MetaInfo")
        
        // entity
        let expectedEntityCode = "public let info: MetaInfoEntity?"
        let generatedEntityCode = try? PropertyGenerator().generateCode(for: fieldNode, type: .entity)
        
        XCTAssert(expectedEntityCode == generatedEntityCode)
        
        // entry
        let expectedEntryCode = "public let info: MetaInfoEntry?"
        let generatedEntryCode = try? PropertyGenerator().generateCode(for: fieldNode, type: .entry)
        
        XCTAssert(expectedEntryCode == generatedEntryCode)
    }
    
    func testStandardFieldCodeGenetaion() {
        let fieldNode = formFieldNode(isOptional: false, name: "value", typeName: "Int")
        let expectedCode = "public let value: Int"
        let generatedCode = try? PropertyGenerator().generateCode(for: fieldNode, type: .entity)
        
        XCTAssert(expectedCode == generatedCode)
    }

}
