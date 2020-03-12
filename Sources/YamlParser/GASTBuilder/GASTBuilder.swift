//
//  GASTBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SurfGenKit
import Swagger

public final class GASTBuiler {

    func build(for models: [ComponentObject<Schema>]) throws -> ASTNode {
        let decls = try models.map { Node(token: .decl, try buildDeclNode(for: $0)) }
        return Node(token: .root, decls)
    }

    func buildDeclNode(for model: ComponentObject<Schema>) throws -> [ASTNode] {
        let nameNode = Node(token: .name(value: model.name), [])
        guard let object = model.value.type.object else {
            throw GASTBuilerError.nonObjectNodeFound(model.name)
        }
        let contentNode     = Node(token: .content, try buildContentSubnodes(for: object))
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

        throw GASTBuilerError.undefinedTypeForField(schemaType.description)
    }

}

private extension SchemaType {

    var description: String {
        switch self {
        case .any:
            return "any"
        case .array(let array):
            return "array of \(array.items)"
        case .boolean:
            return "boolean"
        case .group(let group):
            return "group of \(group.type)"
        case .object(let object):
            return "object of \(object)"
        case .reference(let ref):
            return "refenerence of \(ref.name)"
        case .string(let string):
            return "string of \(string)"
        case .number(let number):
            return "string of \(number)"
        case .integer(let integer):
            return "string of \(integer)"
        }
    }

}
