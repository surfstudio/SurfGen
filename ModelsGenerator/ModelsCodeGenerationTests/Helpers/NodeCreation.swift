//
//  NodeCreation.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 26/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

@testable import ModelsCodeGeneration

func formFieldNode(isOptional: Bool, name: String, typeName: String, typeSubNodes: [Node] = []) -> Node {
    return Node(token: .field(isOptional: isOptional),
                [
                    Node(token: .name(value: name), []),
                    Node(token: .type(name: typeName), typeSubNodes)
                ]
    )
}
