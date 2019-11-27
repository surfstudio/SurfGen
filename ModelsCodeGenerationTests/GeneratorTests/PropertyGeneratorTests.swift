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
        let expectedModel = PropertyGenerationModel(name: "login", type: "String?", isStandardType: true)
        do {
            let generatedModel = try PropertyGenerator().generateCode(for: fieldNode, type: .entity)
            XCTAssert(expectedModel == generatedModel)
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }
    
    func testCustomOptionalFieldCodeGeneration() {
        let fieldNode = formFieldNode(isOptional: true, name: "info", typeName: "MetaInfo")
        let expectedModel = PropertyGenerationModel(name: "info", type: "MetaInfoEntity?", isStandardType: false)

        do {
            let generatedModel = try PropertyGenerator().generateCode(for: fieldNode, type: .entity)
            XCTAssert(expectedModel == generatedModel)
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }

    }

    func testStandardFieldCodeGenetaion() {
        let fieldNode = formFieldNode(isOptional: false, name: "value", typeName: "Int")
        let expectedModel = PropertyGenerationModel(name: "value", type: "Int", isStandardType: true)

        do {
            let generatedModel = try PropertyGenerator().generateCode(for: fieldNode, type: .entry)
            XCTAssert(expectedModel == generatedModel)
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }

}
