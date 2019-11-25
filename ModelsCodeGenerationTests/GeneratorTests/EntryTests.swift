//
//  EntryTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 23/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class EntryTests: XCTestCase {

    func testEntryGeneration() {
        
        // given
        
        let expectedCode = FileReader().readFile("LoginEntry", "txt")
        let exptecedFileName = "LoginEntry.swift"
        
        // when
        
        let declNode = Node(token: .decl,
                            [
                                Node(token: .name(value: "Login"), []),
                                Node(token: .content,
                                     [
                                        formFieldNode(isOptional: true, name: "profile", typeName: "Profile"),
                                        formFieldNode(isOptional: false, name: "id", typeName: "String"),
                                        formFieldNode(isOptional: true, name: "number", typeName: "Int")
                                     ]
                                )
                            ]
        )
        
        let root = Node(token: .root, [declNode])
        
        // then
        
        do {
            let (fileName, code) = (try RootGenerator().generateCode(for: root, type: .entry))[0]
            
            XCTAssert(fileName == exptecedFileName, "File name is not equal to expected one (resulted value is \(fileName)")
            XCTAssert(code == expectedCode, "Code is not equal to expected one (resulted value is \(code)")
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }

}
