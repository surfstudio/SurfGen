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

    func testShopLocationEntryGeneration() {
        
        // given
        
        let expectedCode = FileReader().readFile("ShopLocationEntry", "txt")
        let exptecedFileName = "ShopLocationEntry.swift"
        
        // when
        
        let root = Node(token: .root, [NodesBuilder.formShopLocationDeclNode()])
        
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

    func testShopEntryGeneration() {
           
           // given
           
           let expectedCode = FileReader().readFile("ShopEntry", "txt")
           let exptecedFileName = "ShopEntry.swift"
           
           // when
           
        let root = Node(token: .root, [NodesBuilder.formShopDeclNode()])
           
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
