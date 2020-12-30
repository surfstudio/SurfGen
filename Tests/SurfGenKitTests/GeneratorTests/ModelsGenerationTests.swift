//
//  ModelsGenerationTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 02/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
@testable import SurfGenKit
import PathKit

class ModelsGenerationTests: XCTestCase {

    // MARK: - Testing correct behavior
    
    func testEntityGeneration() {
        TestModels.allCases.forEach { self.checkGeneratedCode(rootSubnodes: $0.rootSubNodes, testType: $0, modelType: .entity) }
    }
    
    func testEntryGeneration() {
        TestModels.allCases.forEach { self.checkGeneratedCode(rootSubnodes: $0.rootSubNodes, testType: $0, modelType: .entry) }
    }
    
    private func checkGeneratedCode(rootSubnodes: [ASTNode], testType: TestModels, modelType: ModelType) {
        // given
        
        let expectedCode = FileReader().readFile("\(testType.getFilePath(for: modelType)).txt")
        let exptecedFileName =  "\(testType.getTestFileName(for: modelType)).swift"
        
        // when
        
        let root = Node(token: .root, rootSubnodes)
        
        // then
        
        do {
            let path = Path(#file) + "../../../../Templates/Swift"
            let genModel = try RootGenerator(tempatesPath: path, platform: .swift).generateModel(from: root,
                                                                                                 types: [modelType])
            let fileName = genModel[modelType]![0].fileName
            let code = genModel[modelType]![0].code

            XCTAssert(fileName == exptecedFileName, "File name is not equal to expected one (resulted value is \(fileName)")
            XCTAssert(code == expectedCode, "Code is not equal to expected one (resulted value is \(code)")
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }

    // MARK: - Testing for errors

    func testErrorForNotRootToken() {
        let errorTokens: [ASTToken] = [.decl, .content, .name(value: ""), .field(isOptional: false), .type(name: "")]
        for errorToken in errorTokens {
            assertThrow(try RootGenerator(platform: .swift).generateModel(from: Node(token: errorToken, []),
                                                                          types: [.entity]),
                        throws: GeneratorError.incorrectNodeToken(""))
        }
    }

}
