//
//  GASTFieldNodeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import Swagger
import SurfGenKit

final class GASTFieldNodeBuilder {

    func buildFieldType(for schemaType: SchemaType) throws -> ASTNode {
        // case schema type is plain: Int, String, Double, Bool
        if let typeName = schemaType.typeName {
            return Node(token: .type(name: typeName), [])
        }

        // case schema type is a reference to object
        if let ref = schemaType.reference {
            return Node(token: .type(name: "object"), [Node(token: .type(name: ref.name), [])])
        }

        // case schema type is an array of any type
        if case let .array(arrayObject) = schemaType, case let .single(subSchema) = arrayObject.items {
            return Node(token: .type(name: "array"), [try buildFieldType(for: subSchema.type)])
        }

        throw GASTBuilderError.undefinedTypeForField(schemaType.description)
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
