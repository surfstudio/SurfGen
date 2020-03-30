//
//  DeclNodeSplitter.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 23/03/2020.
//

final class DeclNodeSplitter {

    func split(nodes: [ASTNode]) -> (objectDecls: [ASTNode], enumDecls: [ASTNode]) {
        var objectDecls: [ASTNode] = []
        var enumDecls: [ASTNode] = []

        for node in nodes {
            guard node.subNodes.contains(where: {
                guard case let .type(name) = $0.token else {
                    return false
                }
                return name == ASTConstants.enum
            }) else {
                objectDecls.append(node)
                continue
            }
            enumDecls.append(node)
        }

        return (objectDecls, enumDecls)
    }

}
