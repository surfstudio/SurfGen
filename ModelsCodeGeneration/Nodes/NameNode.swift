//
//  NameNode.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 26/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public final class NameNode: ASTNode {

    public var next: [ASTNode]
    public let name: String
    
    public init(name: String) {
        self.next = []
        self.name = name
    }
    
    public var nodeToken: ASTToken {
        return .name
    }

}
