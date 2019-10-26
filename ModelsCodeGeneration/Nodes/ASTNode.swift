//
//  ASTNode.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 19/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public protocol ASTNode: class {
    var nodeToken: ASTToken { get }
    var next: [ASTNode] { get }
}
