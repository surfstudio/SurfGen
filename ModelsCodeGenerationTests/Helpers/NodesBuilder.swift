//
//  NodesBuilder.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 27/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

@testable import ModelsCodeGeneration

final class NodesBuilder {

    static func formShopLocationDeclNode() -> Node {
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
                                formFieldNode(isOptional: false, name: "geo_pos", typeName: "Geoposition")
                            ]
                        )
                    ]
        )
    }
    
    static func formShopDeclNode() -> Node {
        return Node(token: .decl,
                            [
                                Node(token: .name(value: "Shop"), []),
                                Node(token: .content,
                                     [
                                        formFieldNode(isOptional: false, name: "id", typeName: "String"),
                                        formFieldNode(isOptional: false, name: "name", typeName: "String"),
                                        formFieldNode(isOptional: false, name: "phone", typeName: "String"),
                                        formFieldNode(isOptional: false, name: "location", typeName: "ShopLocation"),
                                        formFieldNode(isOptional: true, name: "working_hours", typeName: "String")
                                     ]
                                )
                            ]
        )
    }

}
