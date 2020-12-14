//
//  SchemaBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Swagger
import Common

public protocol SchemaBuilder {
    func build(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode]
}

public struct AnySchemaBuilder: SchemaBuilder {

    public func build(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode] {
        var result = [SchemaObjectNode]()
        for schema in schemas {

            let model = try wrap(self.process(schema: schema),
                                 message: "In the schema \(schema.name) where value type is \(schema.value.type)")

            result.append(model)
        }
        return result
    }

    func process(schema: ComponentObject<Schema>) throws -> SchemaObjectNode {
        switch schema.value.type {
        case .reference, .array, .group, .boolean, .any:
            throw CustomError(message: "Now we can't process this type on this level of depth. You can create an Issue or add your vote to existed one")
        case .object(let obj):
            let model = try self.build(object: obj, meta: schema.value.metadata, name: schema.name)
            return .init(next: .object(model))
        case .string:
            return try self.processString(schema: schema)
        case .number, .integer:
            throw CustomError(message: "Now we can't process this type on this level of depth. You can create an Issue or add your vote to existed one")
        }
    }

    func processString(schema: ComponentObject<Schema>) throws -> SchemaObjectNode {
        guard
            let cases = schema.value.metadata.enumValues,
            let stringCases = cases as? [String]
        else {
            throw CustomError(message: "We couldn't parse it as enum (where were no one string case). Now we can't process this type on this level of depth. You can create an Issue or add your vote to existed one")
        }

        let model = SchemaEnumNode(
            type: "string",
            cases: stringCases
        )

        return.init(next: .enum(model))
    }

    func build(object: ObjectSchema, meta: Metadata, name: String) throws -> SchemaModelNode {

        let properties = try object.properties.map { property -> PropertyNode in
            let type = try wrap(property.schema.extractType(),
                                message: "In object \(name), in property \(property.name)")

            return PropertyNode(name: property.name,
                                type: type,
                                description: property.schema.metadata.description,
                                example: property.schema.metadata.example,
                                nullable: property.nullable)
        }

        return SchemaModelNode(name: name, properties: properties, description: meta.description)
    }
}
