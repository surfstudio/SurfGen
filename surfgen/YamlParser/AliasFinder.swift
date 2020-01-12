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

struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}

extension ObjectSchema {

    init(requiredProperties: [Property], optionalProperties: [Property]) throws {
        self.requiredProperties = requiredProperties
        self.optionalProperties = optionalProperties
        self.properties = optionalProperties + requiredProperties
        self.abstract = false
        self.additionalProperties = nil
        self.discriminator = nil
        self.maxProperties = nil
        self.minProperties = nil
    }

}

final class GroupResolver {

    func transfrom(groupComponent: ComponentObject<Schema>) -> SchemaType {
        guard case let .group(groupSchema) = groupComponent.value.type else {
            return groupComponent.value.type
        }

        let object = try! ObjectSchema(requiredProperties: [], optionalProperties: [])
        return SchemaType.object(object)
    }

    /**
     Method finds all properties for provided schema. As it could contain references and groups it recursively goes through all depended schemas
     */
    func findProperties(for schema: Schema) -> (requiredProperties: [Property], optionalProperties: [Property]) {
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
                return (result.0 + curr.0, result.1 + curr.1)
            }
        default:
            return ([], [])
        }
    }

}
