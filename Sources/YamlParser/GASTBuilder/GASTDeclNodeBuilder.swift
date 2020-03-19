//
//  GASTDeclNodeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import Swagger
import SurfGenKit

final class GASTDeclNodeBuilder {

    func buildDeclNode(for model: ComponentObject<Schema>) throws -> ASTNode {
        return model.isEnum ? try buildEnumDecl(for: model) : try buildObjectDecl(for: model)
    }

    private func buildObjectDecl(for model: ComponentObject<Schema>) throws -> ASTNode {
        guard let object = model.value.type.object else {
            throw GASTBuilderError.nonObjectNodeFound(model.name)
        }

        let nameNode = Node(token: .name(value: model.name), [])
        let contentNode = try GASTContentNodeBuilder().buildObjectContentSubnodes(for: object)

        var subNodes: [ASTNode] = [
            nameNode,
            contentNode,
            Node(token: .type(name: "object"), [])
        ]
        if let decription = model.value.metadata.description {
            subNodes.append(Node(token: .description(decription), []))
        }
        return Node(token: .decl, subNodes)
    }

    private func buildEnumDecl(for model: ComponentObject<Schema>) throws -> ASTNode {
        let nameNode = Node(token: .name(value: model.name), [])
        let contentNode = try GASTContentNodeBuilder().buildEnumContentSubnodes(for: model)

        var subNodes: [ASTNode] = [
            nameNode,
            contentNode,
            Node(token: .type(name: "enum"), [])
        ]
        if let decription = model.value.metadata.description {
            subNodes.append(Node(token: .description(decription), []))
        }
        return Node(token: .decl, subNodes)
    }

}


