//
//  AliasFinder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 11/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger

extension SchemaType {

    var typeName: String? {
        switch self {
        case .boolean:
            return "boolean"
        case .string:
            return "string"
        case .number:
            return "number"
        case .integer:
           return "integer"
        default:
            return nil
        }
    }

}

final class AliasFinder {

    func findAlaises(for schemas: [ComponentObject<Schema>]) -> [String: SchemaType] {
        var dict = [String: SchemaType]()
        for schema in schemas where schema.value.type.isPrimitive {
            dict[schema.name] = schema.value.type
        }
        return dict
    }

}

final class AliasResolver {

//    func transfrom(group: SchemaType) -> SchemaType {
//        guard case let .group(groupSchema) = group else {
//            return group
//        }
//
//    }

    func findProperties(for schema: Schema) -> ([Property], [Property]) {
        switch schema.type {
        case .object(let objectSchema):
            return (objectSchema.optionalProperties, objectSchema.requiredProperties)
        case .array(let arraySchema):
            switch arraySchema.items {
            case .single(let singleSchema):
                return findProperties(for: singleSchema)
            default:
                return ([], [])
            }
        case .reference(let refSchema):
            return findProperties(for: refSchema.value)
        case .group(let groupSchema) where groupSchema.type == .all:
            return groupSchema.schemas.map { findProperties(for: $0) }.reduce(([], [])) { (result, curr) -> ([Property], [Property]) in
                return (result.0 + curr.0, result.1 + result.1)
            }
        default:
            return ([], [])
        }
    }

    func resolve(dict: [String: SchemaType], for schemas: [ComponentObject<Schema>]) -> [ComponentObject<Schema>] {
//        for schema in schemas {
//            switch schema.value.type {
//            case .object(let object):
//                for property in object.properties {
//                    guard let refName = property.schema.type.reference?.name, let type = dict[refName] else {
//                        continue
//                    }
//
//                    property.schema =
//                }
////            case .reference(let refSchema):
////                if let type = dict[refSchema.name] {
////                    schema
////                }
//            default:
//                break
//            }
//        }
        return schemas
    }

//    func resolve(dict: [String: String], schema: SchemaType) ->


}
