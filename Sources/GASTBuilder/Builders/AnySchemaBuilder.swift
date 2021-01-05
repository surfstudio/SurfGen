//
//  SchemaBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Swagger
import Common
import GASTTree

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
            throw CustomError(message: "Now we can't process this type on this level of depth. You can create an Issue or add your vote to existed one")
        case .object(let obj):
            let model = try self.build(object: obj, meta: schema.value.metadata, name: schema.name)
            return .init(next: .object(model))
        case .string:
            return try self.processString(schema: schema)
        case .array(let val):
            let arr = try self.build(array: val, name: schema.name)
            return .init(next: .array(arr))
        case .reference(let ref):
            return .init(next: .reference(ref.rawValue))
        case .group(let val):
            let node = try wrap(
                self.build(group: val, name: schema.name),
                message: "While parsing gorup \(schema.name)"
            )
            return .init(next: .group(node))
        case .number:
            return .init(next: .simple(.init(name: schema.name, type: .number)))
        case .integer:
            return .init(next: .simple(.init(name: schema.name, type: .integer)))
        case .boolean:
            return .init(next: .simple(.init(name: schema.name, type: .boolean)))
        }
    }

    func processString(schema: ComponentObject<Schema>) throws -> SchemaObjectNode {

        guard let enumValues = schema.value.metadata.enumValues else {
            return .init(next: .simple(.init(name: schema.name, type: .string)))
        }

        guard let stringCases = enumValues as? [String] else {
            throw CustomError(message: "We couldn't parse it as enum (where were no one string case). Now we can't process this type on this level of depth. You can create an Issue or add your vote to existed one")
        }

        let model = SchemaEnumNode(
            type: "string",
            cases: stringCases,
            name: schema.name
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
                                // TODO: - Swagger lib crash if its a ref. Why? No idea.
//                                nullable: property.nullable)
                                nullable: true)
        }

        return SchemaModelNode(name: name, properties: properties, description: meta.description)
    }

    func build(array: ArraySchema, name: String) throws -> SchemaArrayNode {

        switch array.items {
        case .single(let val):
            let type = try self.process(schema: .init(name: "", value: val))
            return .init(name: name, type: type)
        case .multiple:
            throw CustomError(message: "At this moment SurfGen doesn't support multiple array items")
        }
    }

    func build(group: GroupSchema, name: String) throws -> SchemaGroupNode {

        let refs = try group.schemas.map { schema -> String in
            switch schema.type {
            case .reference(let val):
                return val.rawValue
            case .object:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and object found")
            case .array:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and array found")
            case .group:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and group found")
            case .boolean:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and boolean found")
            case .string:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and string found")
            case .number:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and number found")
            case .integer:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and integer found")
            case .any:
                throw CustomError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and any found")
            }
        }

        return .init(name: name, references: refs, type: group.type.gast)
    }
}
