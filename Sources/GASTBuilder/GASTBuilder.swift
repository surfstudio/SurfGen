//
//  Builder.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Yams
import Swagger
import Common

public protocol GASTBuilder {
    func build(filePath: String) throws -> RootNode
}

public struct AnyGASTBuilder: GASTBuilder {

    let fileProvider: FileProvider

    public init(fileProvider: FileProvider) {
        self.fileProvider = fileProvider
    }

    public func build(filePath: String) throws -> RootNode {

        let fileContent = try fileProvider.readTextFile(at: filePath)

        let spec = try wrap(SwaggerSpec(string: fileContent),
                            message: "Error occured while parsing spec at path \(filePath)")

        let components = try wrap(self.build(components: spec.components), message: "While parsing compenents for specification at path: \(filePath)")

        return .init(components: components)
    }
}

extension AnyGASTBuilder {
    func build(components: Components) throws -> [SchemaObjectNode] {
        return try self.buildComponents(schemas: components.schemas)
    }

    func buildComponents(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode] {
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
            let type = try wrap(self.extractType(propertySchema: property.schema),
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

private extension AnyGASTBuilder {
    func extractType(propertySchema: Schema) throws -> PropertyNode.PossibleType {
        switch propertySchema.type {
        case .any:
            throw CustomError(message: "Type is `any`, but we can process only primitive types, arrays and $ref")
        case .object:
            throw CustomError(message: "Type is `object`, but we can process only primitive types, arrays and $ref")
        case .group:
            throw CustomError(message: "Type is `group`, but we can process only primitive types, arrays and $ref")
        case .array(let arr):
            switch arr.items {
            case .multiple:
                throw CustomError(message: "Array conains multiple items declaration. So we can't process it now")
            case .single(let schema):
                let type = try self.extractType(propertySchema: schema)
                guard case .simple(let val) = type else {
                    throw CustomError(message: "Array conains single item with wrong type \(type). but we can process only primitive types and $ref in this case")
                }
                return .array(.init(itemsType: val))
            }
        case .reference(let ref):
            return .simple(.ref(ref.rawValue))
        case .boolean:
            return .simple(.entity("boolean"))
        case .string:
            return .simple(.entity("string"))
        case .number:
            return .simple(.entity("number"))
        case .integer:
            return .simple(.entity("integer"))
        }
    }
}
