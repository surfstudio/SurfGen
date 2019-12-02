//
//  NodesValidator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class NodesValidator {

    static func getInfo(from declNode: ASTNode) throws -> (name: String, fields: [ASTNode]) {

        guard declNode.subNodes.count == 2 else {
            throw GeneratorError.incorrectNodeNumber("decl node does not cointain expected 2 subnodes")
        }

        guard let node = declNode.subNodes.last, case .content = node.token else {
            throw GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node")
        }

        guard case let .name(value) = declNode.subNodes.first?.token else {
            throw GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node")
        }

        return (value, node.subNodes)
    }

}
