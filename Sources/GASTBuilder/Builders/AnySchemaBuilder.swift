//
//  AnySchemaBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Swagger
import Common
import GASTTree

/// Just an interface for any GAST-Schema builder
public protocol SchemaBuilder {
    /// Build all item which are under `schemas:`
    func build(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode]
}

/// Default implementation of `schema` builder.
///
/// ```YAML
/// components:
///     schemas: # <-- Will build all items under this key
/// ```
///
/// - See: https://swagger.io/docs/specification/data-models/
///
/// ## Don't support
///
/// ### Group type may be only reference.
///
/// For example it's **ok**
///
/// ```YAML
/// oneOf:
///     - $ref: "..."
///     - type: integer
/// ```
///
/// but it's **not**
///
/// ### Array may by only single-item
///
/// ```YAML
/// type: array
/// items:
///     type: integer
/// ```
/// **Not multiple**
///
/// ```YAML
/// type: array
/// items:
///     type:
///         - integer
///         - string
/// ```
/// ### PrimitiveType can't be `any`
///
/// Isn't supported in any place
public struct AnySchemaBuilder: SchemaBuilder {

    public init() { }

    /// Build all item which are under `schemas:`
    public func build(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode] {
        var result = [SchemaObjectNode]()
        for schema in schemas {

            let model = try wrap(self.process(schema: schema),
                                 message: "In the schema \(schema.name) where value type is \(schema.value.type.shortDescription)")

            result.append(model)
        }
        return result
    }

    /// Build current `schemas` element
    func process(schema: ComponentObject<Schema>) throws -> SchemaObjectNode {
        switch schema.value.type {
        case .any:
            throw CommonError(message: "Now we can't process this type on this level of depth. You can create an Issue or add your vote to existed one")
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

    /// Handle component whose type is string
    /// Can create `primitive` or `enum`
    func processString(schema: ComponentObject<Schema>) throws -> SchemaObjectNode {

        guard let enumValues = schema.value.metadata.enumValues else {
            return .init(next: .simple(.init(name: schema.name, type: .string)))
        }

        guard let stringCases = enumValues as? [String] else {
            throw CommonError(message: "We couldn't parse it as enum (where were no one string case)")
        }

        let model = SchemaEnumNode(
            type: "string",
            cases: stringCases,
            name: schema.name,
            description: schema.value.metadata.description
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
                                nullable: property.isNullable)
        }

        return SchemaModelNode(name: name, properties: properties, description: meta.description)
    }

    func build(array: ArraySchema, name: String) throws -> SchemaArrayNode {

        switch array.items {
        case .single(let val):
            let type = try self.process(schema: .init(name: "", value: val))
            return .init(name: name, type: type)
        case .multiple:
            throw CommonError(message: "At this moment SurfGen doesn't support multiple array items")
        }
    }

    /// Build group node and validate group type
    /// For detail look at header
    func build(group: GroupSchema, name: String) throws -> SchemaGroupNode {

        let refs = try group.schemas.map { schema -> String in
            switch schema.type {
            case .reference(let val):
                return val.rawValue
            case .object:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and object found")
            case .array:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and array found")
            case .group:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and group found")
            case .boolean:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and boolean found")
            case .string:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and string found")
            case .number:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and number found")
            case .integer:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and integer found")
            case .any:
                throw CommonError(message: "SurfGen support only references on groups (allOf, oneOf, anyOf). But and any found")
            }
        }

        return .init(name: name, references: refs, type: group.type.gast)
    }
}

private extension Schema {

    func extractType() throws -> PropertyNode.PossibleType {
        switch self.type {
        case .any:
            throw CommonError(message: "Type is `any`, but we can process only primitive types, arrays and $ref")
        case .object:
            throw CommonError(message: "Type is `object`, but we can process only primitive types, arrays and $ref")
        case .group:
            throw CommonError(message: "Type is `group`, but we can process only primitive types, arrays and $ref")
        case .array(let arr):
            switch arr.items {
            case .multiple:
                throw CommonError(message: "Array conains multiple items declaration. So we can't process it now")
            case .single(let schema):
                let type = try schema.extractType()
                guard case .simple(let val) = type else {
                    throw CommonError(message: "Array conains single item with wrong type \(type). But we can process only primitive types and $ref in this case")
                }
                return .array(.init(itemsType: val))
            }
        case .reference(let ref):
            return .simple(.ref(ref.rawValue))
        case .boolean:
            return .simple(.entity(.boolean))
        case .string:
            return .simple(.entity(.string))
        case .number:
            return .simple(.entity(.number))
        case .integer:
            return .simple(.entity(.integer))
        }
    }
}

private extension Property {

    // This is the correct way to detect nullable properties
    // TODO: move this logic to Swagger lib
    var isNullable: Bool {
        return !required || schema.metadata.nullable
    }
    
}
