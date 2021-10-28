//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Common

public protocol MediaTypeParser {
    func parse(mediaType: MediaTypeObjectNode,
               current: DependencyWithTree,
               other: [DependencyWithTree]) throws -> DataModel
}

public struct AnyMediaTypeParser: MediaTypeParser {

    public let arrayParser: ArrayParser
    public let groupParser: AnyGroupParser

    private let resolver: Resolver

    public init(arrayParser: ArrayParser,
                groupParser: AnyGroupParser, resolver: Resolver) {
        self.arrayParser = arrayParser
        self.groupParser = groupParser
        self.resolver = resolver
    }

    public func parse(mediaType: MediaTypeObjectNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> DataModel {

        let value = try self.parse(schema: mediaType.schema, current: current, other: other)

        return .init(mediaType: mediaType.typeName, type: value)
    }

    public func parse(schema: SchemaObjectNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> DataModel.PossibleType {
        // got media type schema
        // it can be ref or in-place declaration
        // in-place declaration is unsupported
        switch schema.next {
        case .object:
            throw CommonError(message: "MediaType shouldn't contains object definition. Only refs (and arr with refs) supported")
        case .enum:
            throw CommonError(message: "MediaType shouldn't contains enum definition. Only refs (and arr with refs) supported")
        case .simple:
            throw CommonError(message: "MediaType shouldn't contains alias definition. Only refs (and arr with refs) supported")
        case .array(let val):
            let parsed = try self.arrayParser.parse(array: val, current: current, other: other)
            return .array(parsed)
        case .reference(let val):
            return try self.parse(ref: val, current: current, other: other)
        case .group(let val):
            let group = try wrap(
                self.groupParser.parse(group: val, current: current, other: other),
                message: "While parsing group \(val.name)"
            )
            return .group(group)
        }
    }

    func parse(ref: String, current: DependencyWithTree, other: [DependencyWithTree]) throws -> DataModel.PossibleType {
        let schemaType = try wrap(
            resolver.resolveSchema(ref: ref, node: current, other: other),
            message: "While resolving \(ref) at file \(current.dependency.pathToCurrentFile)"
        )

        // if resolving works then we should  check that response or request contains object
        // we just don't know what we should deal with plain entites

        switch schemaType {
        case .alias:
            throw CommonError(message: "MediaType shouldn't contains ref on alias. Only objects are supported")
        case .enum:
            throw CommonError(message: "MediaType shouldn't contains ref on enum. Only objects are supported")
        case .object(let val):
            return .object(val)
        case .array(let val):
            return .array(val)
        case .group(let val):
            return .group(val)
        }
    }
}
