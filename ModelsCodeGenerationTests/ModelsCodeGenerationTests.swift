//
//  ModelsCodeGenerationTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 19/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class ModelsCodeGenerationTests: XCTestCase {

    var root: RootNode!

    override func setUp() {
        root = RootNode([
            formDeclNode(with: "Auth", fieldNames: ["login", "password", "device"]),
            formDeclNode(with: "Register", fieldNames: ["test", "field", "device"]),
            formDeclNode(with: "User", fieldNames: ["name", "surname", "region"])
        ])
    }

    func formDeclNode(with name: String, fieldNames: [String]) -> ASTNode {
        let name = NameNode(name: name)
        let fields = fieldNames.map { FieldNode([NameNode(name: $0), TypeNode(name: "String")]) }
        let content = ContentNode(fields)
        return DeclNode([name, content])
    }

    // just to see the concent result
    func testExample() {
        let files = CodeGenerator().generateEntitiesCode(for: root, type: .entity)
        files.forEach { print($0) }
    }

}
