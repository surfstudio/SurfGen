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
    /// If set to `false` disable errors for cases when MediaType schema cotains definition of object/enum/alias e.t.c
    /// If set to `true` throws error for any case except reference
    /// By default set to `true`
    public let enableDisclarationChecking: Bool

    public init(schemaBuilder: SchemaBuilder, enableDisclarationChecking: Bool = true) {
        self.schemaBuilder = schemaBuilder
        self.enableDisclarationChecking = enableDisclarationChecking
    }

    public func buildMediaItems(items: [String: MediaItem]) throws -> [MediaTypeObjectNode] {
        return try items.map { key, value -> MediaTypeObjectNode in
            let schema = try wrap(
                self.schemaBuilder.build(schemas: [.init(name: "", value: value.schema)]),
                message: "While build body")

            guard schema.count == 1 else {
                throw CommonError(message: "We had sent 1 schema, and then got \(schema.count). It's very strange. Plz contact mainteiners")
            }

            switch schema[0].next {
            case .object where enableDisclarationChecking:
                throw CommonError(message: "MediaType shouldn't contains object definition. Only refs supported")
            case .enum where enableDisclarationChecking:
                throw CommonError(message: "MediaType shouldn't contains object definition. Only refs supported")
            case .simple where enableDisclarationChecking:
                throw CommonError(message: "MediaType shouldn't contains object definition. Only refs supported")
            case .reference:
                break
            default:
                break
            }

            return MediaTypeObjectNode(typeName: key, schema: schema[0])
        }
    }
}
