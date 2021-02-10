//
//  ServiceDeclNodeParser.swift
//  
//
//  Created by Dmitry Demyanov on 30.10.2020.
//

struct ServiceDeclaration {
    let name: String
    let operations: [ASTNode]
}

class ServiceDeclNodeParser {

    private enum Constants {
        static let errorMessage = "Could not get info from service decl node"
    }

    func getInfo(from declNode: ASTNode) throws -> ServiceDeclaration {
        // find content node
        guard let contentNode = declNode.subNodes.contentNode else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node"),
                               message: Constants.errorMessage)
        }
        // find name node
        guard let nameNode = declNode.subNodes.nameNode, case let .name(name) = nameNode.token else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node"),
                               message: Constants.errorMessage)
        }

        return .init(name: name, operations: contentNode.subNodes)
    }

}
