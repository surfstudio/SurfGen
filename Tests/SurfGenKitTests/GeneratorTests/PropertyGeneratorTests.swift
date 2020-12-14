//
//  PropertyGeneratorTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import SurfGenKit

class PropertyGeneratorTests: XCTestCase {

    private let generator = PropertyGenerator(platform: .swift)
    
    func testStandardOptionalFieldCodeGeneration() {
        let fieldNode = formFieldNode(isOptional: true, name: "login", typeName: "string")
        let expectedModel = PropertyGenerationModel(entryName: "login",
                                                    entityName: "login",
                                                    typeName: "String",
                                                    fromInit: "model.login",
                                                    toDTOInit: "login",
                                                    isPlain: true,
                                                    isOptional: true,
                                                    description: nil)
        do {
            let generatedModel = try generator.generateCode(for: fieldNode, type: .entity)
            XCTAssert(expectedModel == generatedModel)
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }

    func testObjectOptionalFieldCodeGeneration() {
        let fieldNode = formFieldNode(isOptional: true,
                                      name: "info",
                                      typeName: ASTConstants.object,
                                      typeSubNodes: [Node(token: .type(name: "MetaInfo"), [])])
        let expectedModel = PropertyGenerationModel(entryName: "info",
                                                    entityName: "info",
                                                    typeName: "MetaInfoEntity",
                                                    fromInit: ".from(dto: model.info)",
                                                    toDTOInit: "info?.toDTO()",
                                                    isPlain: false,
                                                    isOptional: true,
                                                    description: nil)

        do {
            let generatedModel = try generator.generateCode(for: fieldNode, type: .entity)
            XCTAssert(expectedModel == generatedModel)
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }

    }

    func testArrayOfStandardTypeFieldCodeGenetaion() {
        let fieldNode = formFieldNode(isOptional: false,
                                      name: "working_hours",
                                      typeName: "array",
                                      typeSubNodes: [Node(token: .type(name: "string"), [])])
        let expectedModel = PropertyGenerationModel(entryName: "working_hours",
                                                    entityName: "workingHours",
                                                    typeName: "[String]",
                                                    fromInit: "model.working_hours",
                                                    toDTOInit: "workingHours",
                                                    isPlain: true,
                                                    isOptional: false,
                                                    description: nil)

        do {
            let generatedModel = try generator.generateCode(for: fieldNode, type: .entry)
            XCTAssert(expectedModel == generatedModel)
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }
    
    func testArrayOfObjectsFieldCodeGenetaion() {
        let fieldNode = formFieldNode(isOptional: true,
                                      name: "children",
                                      typeName: "array",
                                      typeSubNodes: [Node(token: .type(name: ASTConstants.object),
                                                          [Node(token: .type(name: "Child"), [])])])
        let expectedModel = PropertyGenerationModel(entryName: "children",
                                                    entityName: "children",
                                                    typeName: "[ChildEntity]",
                                                    fromInit: ".from(dto: model.children)",
                                                    toDTOInit: "children?.toDTO()",
                                                    isPlain: false,
                                                    isOptional: true,
                                                    description: nil)

        do {
            let generatedModel = try generator.generateCode(for: fieldNode, type: .entity)
            XCTAssert(expectedModel == generatedModel)
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }

}
