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

//extension ObjectSchema {
//
//    init(requiredProperties: [Property], optionalProperties: [Property]) throws {
//        self.requiredProperties = requiredProperties
//        self.optionalProperties = optionalProperties
//        self.properties = optionalProperties + requiredProperties
//        self.abstract = false
//        self.additionalProperties = nil
//        self.discriminator = nil
//        self.maxProperties = nil
//        self.minProperties = nil
//    }
//
//}

final class GroupResolver {

//    func transfrom(groupComponent: ComponentObject<Schema>) -> SchemaType {
//        guard case let .group(groupSchema) = groupComponent.value.type else {
//            return groupComponent.value.type
//        }
//
//        let object = try! ObjectSchema(requiredProperties: [], optionalProperties: [])
//        return SchemaType.object(object)
//    }


}
