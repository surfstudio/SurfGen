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

    func testEntryCodeGeneration() {
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
        do {
            let models = try RootGenerator().generateCode(for: root, type: .entry)
            models.forEach { print($0) }
        } catch {
            dump(error)
        }
    }

}

func formFieldNode(isOptional: Bool, name: String, typeName: String) -> Node {
    return Node(token: .field(isOptional: isOptional),
                [
                    Node(token: .name(value: name), []),
                    Node(token: .type(name: typeName), [])
                ]
    )
}

