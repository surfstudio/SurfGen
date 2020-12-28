//
//  File.swift
//
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import Common
import ReferenceExtractor
import GASTBuilder
import GASTTree
import Pipelines
import CodeGenerator

/// It's just a stub object that down't throw errors if request or response contains in=place definition
/// this needs for e-2-e tests which are check another cases of specfification
/// And this stub drammatically decrease amount of yaml spec lines which we should write
public struct AnyMediaTypeParserStub: MediaTypeParser {

    public init() { }

    public func parse(mediaType: MediaTypeObjectNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> DataModel {

        let value = try self.parse(schema: mediaType.schema, current: current, other: other)

        return .init(mediaType: mediaType.typeName, referencedValue: value)
    }

    public func parse(schema: SchemaObjectNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> SchemaObjectModel {
        // got media type schema
        // it can be ref or in-place declaration
        // in-place declaration is unsupported
        switch schema.next {
        case .object:
            return SchemaObjectModel(name: "", properties: [], description: nil)
        case .enum:
            return SchemaObjectModel(name: "", properties: [], description: nil)
        case .simple:
            return SchemaObjectModel(name: "", properties: [], description: nil)
        case .reference(let val):
            let schemaType = try wrap(
                Resolver().resolveSchema(ref: val, node: current, other: other),
                message: "While resolving \(val) at file \(current.dependency.pathToCurrentFile)"
            )

            // if resolving works then we should  check that response or request contains object
            // we just don't know what we should deal with plain entites

            switch schemaType {
            case .alias:
                return SchemaObjectModel(name: "", properties: [], description: nil)
            case .enum:
                return SchemaObjectModel(name: "", properties: [], description: nil)
            case .object(let val):
                return val
            }
        case .array(let arr):
            throw CustomError.notInplemented()
        }
    }
}