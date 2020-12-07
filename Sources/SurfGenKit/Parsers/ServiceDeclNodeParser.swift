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

    func getInfo(from declNode: ASTNode) throws -> ServiceDeclaration {
        // find content node
        guard let contentNode = declNode.subNodes.contentNode else {
            throw GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node")
        }
        // find name node
        guard let nameNode = declNode.subNodes.nameNode, case let .name(name) = nameNode.token else {
            throw GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node")
        }

        return .init(name: name, operations: contentNode.subNodes)
    }

}
