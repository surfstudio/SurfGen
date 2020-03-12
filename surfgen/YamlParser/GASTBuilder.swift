//
//  GASTBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SurfGenKit
import Swagger

enum GASTBuilerError: Error {
    case undefinedTypeForField
    case nonObjectNodeFound
}

public final class GASTBuiler {

    func build(for models: [ComponentObject<Schema>]) throws -> ASTNode {
        let decls = try models.map { Node(token: .decl, try buildDeclNode(for: $0)) }
        return Node(token: .root, decls)
    }

    func buildDeclNode(for model: ComponentObject<Schema>) throws -> [ASTNode] {
        let nameNode = Node(token: .name(value: model.name), [])
        guard let object = model.value.type.object else {
            throw GASTBuilerError.nonObjectNodeFound
        }
        let contentNode = Node(token: .content, try buildContentSubnodes(for: object))
        return [nameNode, contentNode]
    }

    func buildContentSubnodes(for object: ObjectSchema) throws -> [ASTNode] {
        var fieldNodes = [ASTNode]()
        for property in object.properties {
            fieldNodes.append(Node(token: .field(isOptional: !property.required),
                                   [Node(token: .name(value: property.name), []), try buildFieldType(for: property.schema.type)]))
        }
        return fieldNodes
    }

    func buildFieldType(for schemaType: SchemaType) throws -> ASTNode {
        if let typeName = schemaType.typeName {
            return Node(token: .type(name: typeName), [])
        }

        if let ref = schemaType.reference {
            return Node(token: .type(name: "object"), [Node(token: .type(name: ref.name), [])])
        }

        if case let .array(arrayObject) = schemaType, case let .single(subSchema) = arrayObject.items {
            return Node(token: .type(name: "array"), [try buildFieldType(for: subSchema.type)])
        }

        throw GASTBuilerError.undefinedTypeForField
    }

}
