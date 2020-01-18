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


final class GroupResolver {

    func resolve(for schemas: [ComponentObject<Schema>]) -> [ComponentObject<Schema>] {
        return schemas.map(transfrom)
    }

    func transfrom(groupComponent: ComponentObject<Schema>) -> ComponentObject<Schema> {
        guard case .group = groupComponent.value.type else {
            return groupComponent
        }

        let (required, optional) = PropertiesFinder().findProperties(for: groupComponent.value)
        let object = ObjectSchema(requiredProperties: required,
                                  optionalProperties: optional,
                                  properties: required + optional)

        return ComponentObject(name: groupComponent.name, value: Schema(metadata: .init(), type: .object(object)))
    }

}
