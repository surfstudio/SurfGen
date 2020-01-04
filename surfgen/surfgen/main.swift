//
//  main.swift
//  surfgen
//
//  Created by Mikhail Monakov on 04/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import MacOSModelsCodeGeneration

print("shit")

func formShopLocationDeclNode() -> Node {
    return Node(token: .decl,
                [
                    Node(token: .name(value: "ShopLocation"), []),
                    Node(token: .content,
                         [
                            formFieldNode(isOptional: false, name: "region", typeName: "String"),
                            formFieldNode(isOptional: false, name: "city", typeName: "String"),
                            formFieldNode(isOptional: false, name: "address", typeName: "String"),
                            formFieldNode(isOptional: true, name: "floor", typeName: "String"),
                            formFieldNode(isOptional: true, name: "sector", typeName: "String"),
                            formFieldNode(isOptional: false,
                                          name: "geo_pos",
                                          typeName: "object",
                                          typeSubNodes: [Node(token: .type(name: "Geoposition"), [])])
                        ]
                    )
                ]
    )
}

func formFieldNode(isOptional: Bool, name: String, typeName: String, typeSubNodes: [Node] = []) -> Node {
    return Node(token: .field(isOptional: isOptional),
                [
                    Node(token: .name(value: name), []),
                    Node(token: .type(name: typeName), typeSubNodes)
                ]
    )
}

let root = Node(token: .root, [formShopLocationDeclNode()])

do {
    let test = try RootGenerator().generateCode(for: root, type: .entity)
    dump(test)
} catch {
    dump(error)
}

