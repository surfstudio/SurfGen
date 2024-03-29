//
//  GASTDeclNodeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import Swagger
import SurfGenKit

final class GASTDeclNodeBuilder {

    private let contentNodeBuilder: GASTContentNodeBuilder

    init(contentNodeBuilder: GASTContentNodeBuilder) {
        self.contentNodeBuilder = contentNodeBuilder
    }

    func buildDeclNode(for model: ComponentObject<Schema>) throws -> ASTNode {
        return model.isEnum ? try buildEnumDecl(for: model) : try buildObjectDecl(for: model)
    }

    func buildDeclNode(forRootPath rootPath: String, with operations: [Operation]) throws -> ASTNode {
        let nameNode = Node(token: .name(value: rootPath), [])
        let contentNode = try GASTContentNodeBuilder().buildServiceContentSubnodes(with: operations)
        return Node(token: .decl, [nameNode, contentNode])
    }

    private func buildObjectDecl(for model: ComponentObject<Schema>) throws -> ASTNode {
        guard let object = model.value.type.object else {
            throw SurfGenError(nested: GASTBuilderError.nonObjectNodeFound(model.name),
                               message: "Could not build object declaration")
        }

        let nameNode = Node(token: .name(value: model.name), [])
        let contentNode = try GASTContentNodeBuilder().buildObjectContentSubnodes(for: object)

        var subNodes: [ASTNode] = [
            nameNode,
            contentNode,
            Node(token: .type(name: ASTConstants.object), [])
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
            Node(token: .type(name: ASTConstants.enum), [Node(token: .type(name: model.value.type.typeName ?? ""), [])])
        ]
        if let decription = model.value.metadata.description {
            subNodes.append(Node(token: .description(decription), []))
        }
        return Node(token: .decl, subNodes)
    }

}


