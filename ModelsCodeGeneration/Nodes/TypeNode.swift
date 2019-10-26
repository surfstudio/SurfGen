//
//  TypeNode.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 26/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public final class TypeNode: ASTNode {

    public var next: [ASTNode]
    public let typeName: String

    public init(name: String) {
        self.next = []
        self.typeName = name
    }

    public var nodeToken: ASTToken {
        return .type
    }

}
