//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import Swagger
import GASTTree
import Common

public protocol MediaTypesBuilder {
    func buildMediaItems(items: [String: MediaItem]) throws -> [MediaTypeObjectNode]
}

public struct AnyMediaTypesBuilder: MediaTypesBuilder {

    public let schemaBuilder: SchemaBuilder
    /// If set to `true` disable errors for cases when MediaType schema cotains definition of object/enum/alias e.t.c
    /// If set to `false` throws error for any case except reference
    /// By default set to `false`
    public let allowAllTypesOfSchema: Bool

    public init(schemaBuilder: SchemaBuilder, allowAllTypesOfSchema: Bool = false) {
        self.schemaBuilder = schemaBuilder
        self.allowAllTypesOfSchema = allowAllTypesOfSchema
    }

    public func buildMediaItems(items: [String: MediaItem]) throws -> [MediaTypeObjectNode] {
        return try items.map { key, value -> MediaTypeObjectNode in
            let schema = try wrap(
                self.schemaBuilder.build(schemas: [.init(name: "", value: value.schema)]),
                message: "While build request body")

            guard schema.count == 1 else {
                throw CustomError(message: "We had sent 1 schema, and then got \(schema.count). It's very strange. Plz contact mainteiners")
            }

            switch schema[0].next {
            case .object where allowAllTypesOfSchema:
                throw CustomError(message: "MediaType shouldn't contains object definition. Only refs supported")
            case .enum where allowAllTypesOfSchema:
                throw CustomError(message: "MediaType shouldn't contains object definition. Only refs supported")
            case .simple where allowAllTypesOfSchema:
                throw CustomError(message: "MediaType shouldn't contains object definition. Only refs supported")
            case .reference:
                break
            default:
                break
            }

            return MediaTypeObjectNode(typeName: key, schema: schema[0])
        }
    }
}
