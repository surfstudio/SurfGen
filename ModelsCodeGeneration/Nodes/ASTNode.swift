//
//  ASTNode.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 19/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public protocol ASTNode: class {
    var token: ASTToken { get }
    var subNodes: [ASTNode] { get }
}

public class Node: ASTNode {
    
    public var token: ASTToken
    public var subNodes: [ASTNode]
    
    public init(token: ASTToken, _ subNodes: [ASTNode]) {
        self.token = token
        self.subNodes = subNodes
    }

}
