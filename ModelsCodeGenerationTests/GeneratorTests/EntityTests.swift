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
    
    
    func testShopLocationEntityGeneration() {

        // given

        let expectedCode = FileReader().readFile("ShopLocationEntity", "txt")
        let exptecedFileName = "ShopLocationEntity.swift"

        // when

        let root = Node(token: .root, [NodesBuilder.formShopLocationDeclNode()])

        // then

        do {
            let (fileName, code) = (try RootGenerator().generateCode(for: root, type: .entity))[0]

            XCTAssert(fileName == exptecedFileName, "File name is not equal to expected one (resulted value is \(fileName)")
            XCTAssert(code == expectedCode, "Code is not equal to expected one (resulted value is \(code)")
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }

    }

    func testShopEntityGeneration() {
        
        // given
        
        let expectedCode = FileReader().readFile("ShopEntity", "txt")
        let exptecedFileName = "ShopEntity.swift"
        
        // when

        let root = Node(token: .root, [NodesBuilder.formShopDeclNode()])
        
        // then
        
        do {
            let (fileName, code) = (try RootGenerator().generateCode(for: root, type: .entity))[0]

            XCTAssert(fileName == exptecedFileName, "File name is not equal to expected one (resulted value is \(fileName)")
            XCTAssert(code == expectedCode, "Code is not equal to expected one (resulted value is \(code)")
        } catch {
            dump(error)
            assertionFailure("Code generation thrown an exception")
        }
    }
   

}
