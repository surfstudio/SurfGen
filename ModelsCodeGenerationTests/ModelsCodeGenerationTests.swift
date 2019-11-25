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

