//
//  EntityTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 26/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class EntityTests: XCTestCase {

    func testEntryGeneration() {
        
        // given
        
        let expectedCode = FileReader().readFile("ShopEntity", "txt")
        let exptecedFileName = "ShopEntity.swift"
        
        // when
        
        let declNode = Node(token: .decl,
                            [
                                Node(token: .name(value: "Shop"), []),
                                Node(token: .content,
                                     [
                                        formFieldNode(isOptional: false, name: "id", typeName: "String"),
                                        formFieldNode(isOptional: false, name: "name", typeName: "String"),
                                        formFieldNode(isOptional: false, name: "phone", typeName: "String"),
                                        formFieldNode(isOptional: false, name: "location", typeName: "ShopLocation")
                                     ]
                                )
                            ]
        )
        
        let root = Node(token: .root, [declNode])
        
        // then
        
        do {
            let (fileName, code) = (try RootGenerator().generateCode(for: root, type: .entity))[0]
            print(fileName)
            
            print(code)
//            XCTAssert(fileName == exptecedFileName, "File name is not equal to expected one (resulted value is \(fileName)")
//            XCTAssert(code == expectedCode, "Code is not equal to expected one (resulted value is \(code)")
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }
   

}
