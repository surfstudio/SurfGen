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

    public init() { }

    public func build(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode] {
        var result = [SchemaObjectNode]()
        for schema in schemas {

            let model = try wrap(self.process(schema: schema),
                                 message: "In the schema \(schema.name) where value type is \(schema.value.type.shortDescription)")

            result.append(model)
        }
        return result
    }

    func process(schema: ComponentObject<Schema>) throws -> SchemaObjectNode {
        switch schema.value.type {
        case .any:
            // TODO: It's about aliases. we need to implement it. except .any
            throw CustomError(message: "Now we can't process this type on this level of depth. You can create an Issue or add your vote to existed one")
        case .object(let obj):
            let model = try self.build(object: obj, meta: schema.value.metadata, name: schema.name)
            return .init(next: .object(model))
        case .string:
            return try self.processString(schema: schema)
        case .array:
            throw CustomError.notInplemented()
        case .reference:
            throw CustomError.notInplemented()
        case .group:
            throw CustomError.notInplemented()
        case .number:
            return .init(next: .simple(.number))
        case .integer:
            return .init(next: .simple(.integer))
        case .boolean:
            return .init(next: .simple(.boolean))
        }
    }

    func processString(schema: ComponentObject<Schema>) throws -> SchemaObjectNode {

        guard let enumValues = schema.value.metadata.enumValues else {
            return .init(next: .simple(.string))
        }

        guard let stringCases = enumValues as? [String] else {
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
