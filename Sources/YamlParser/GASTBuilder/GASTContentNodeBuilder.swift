//
//  GASTContentNodeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import Swagger
import SurfGenKit

final class GASTContentNodeBuilder {

    func buildContentSubnodes(for object: ObjectSchema) throws -> ASTNode {
        return Node(token: .content, try buildSubnodes(for: object))
    }

    private func buildSubnodes(for object: ObjectSchema) throws -> [ASTNode] {
        let builder = GASTFieldNodeBuilder()
        var fieldNodes = [ASTNode]()
        for property in object.properties {
            fieldNodes.append(Node(token: .field(isOptional: !property.required),
                                   [Node(token: .name(value: property.name), []),
                                    try builder.buildFieldType(for: property.schema.type)]))
        }
        return fieldNodes
    }

}
