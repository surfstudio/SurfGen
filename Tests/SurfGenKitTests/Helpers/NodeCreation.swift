//
//  NodeCreation.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 26/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

@testable import SurfGenKit

func formFieldNode(isOptional: Bool, name: String, typeName: String, typeSubNodes: [Node] = [], description: String? = nil) -> Node {
    var filedSubnodes: [Node] =  [
        Node(token: .name(value: name), []),
        Node(token: .type(name: typeName), typeSubNodes)
    ]
    if let description = description {
        filedSubnodes.append(Node(token: .description(description), []))
    }
    return Node(token: .field(isOptional: isOptional), filedSubnodes)
}
