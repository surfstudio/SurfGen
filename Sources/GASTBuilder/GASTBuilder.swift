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
    func build(filePath: String) throws
}

public struct AnyGASTBuilder: GASTBuilder {

    let fileProvider: FileProvider

    public init(fileProvider: FileProvider) {
        self.fileProvider = fileProvider
    }

    public func build(filePath: String) throws {

        let fileContent = try fileProvider.readTextFile(at: filePath)

        let spec = try wrap(try SwaggerSpec(string: fileContent), message: "Error occured while parsing spec at path \(filePath)")

        try self.build(components: spec.components)
    }
}

extension AnyGASTBuilder {
    func build(components: Components) throws {
        try self.build(schemas: components.schemas)
    }

    func build(schemas: [ComponentObject<Schema>]) throws {
        for schema in schemas {
            if let obj = schema.value.type.object {
                let models = try self.build(object: obj, meta: schema.value.metadata, name: schema.name)
                print(models.view)
            }
        }
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
