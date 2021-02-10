//
//  NodesValidator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

struct ModelDeclaration {
    let name: String
    let description: String?
    let type: String
    let fields: [ASTNode]
}

final class ModelDeclNodeParser {

    private enum Constants {
        static let errorMessage = "Could not get model declaration info"
    }

    /**
     Method resolves decl node for its name, description, type type, fileds subnodes
    */
    func getInfo(from declNode: ASTNode) throws -> ModelDeclaration {
        // find content node
        guard let contentIndex = declNode.subNodes.indexOf(.content) else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node"),
                               message: Constants.errorMessage)
        }
        // find name node
        guard let nameNode = declNode.subNodes.nameNode, case let .name(name) = nameNode.token else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node"),
                               message: Constants.errorMessage)
        }
        // find type node
        guard let typeNode = declNode.subNodes.typeNode, case let .type(typeName) = typeNode.token else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("type node couldn't be resolved for decl node"),
                               message: Constants.errorMessage)
        }

        return .init(name: name,
                     description: declNode.description,
                     type: typeName,
                     fields: declNode.subNodes[contentIndex].subNodes)
    }

}
