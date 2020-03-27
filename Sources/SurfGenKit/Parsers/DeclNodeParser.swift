//
//  NodesValidator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

struct DeclModel {
    let name: String
    let description: String?
    let type: String
    let fields: [ASTNode]
}

final class DeclNodeParser {

    /**
     Method resolves decl node for its name, description, type type, fileds subnodes
    */
    func getInfo(from declNode: ASTNode) throws -> DeclModel {
        // find content node
        guard let contentIndex = declNode.subNodes.indexOf(.content) else {
            throw GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node")
        }
        // find name node
        guard let nameNode = declNode.subNodes.nameNode, case let .name(name) = nameNode.token else {
            throw GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node")
        }
        // find type node
        guard let typeNode = declNode.subNodes.typeNode, case let .type(typeName) = typeNode.token else {
            throw GeneratorError.nodeConfiguration("type node couldn't be resolved for decl node")
        }

        var description: String?
        if let descNode = declNode.subNodes.descriptionNode, case let .description(desc) = descNode.token {
            description = desc
        }

        return .init(name: name,
                     description: description,
                     type: typeName,
                     fields: declNode.subNodes[contentIndex].subNodes)
    }

}
