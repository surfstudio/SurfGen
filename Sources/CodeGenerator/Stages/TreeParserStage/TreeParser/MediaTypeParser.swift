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

    public init(arrayParser: ArrayParser) {
        self.arrayParser = arrayParser
    }

    public func parse(mediaType: MediaTypeObjectNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> DataModel {

        let value = try self.parse(schema: mediaType.schema, current: current, other: other)

        return .init(mediaType: mediaType.typeName, referencedValue: value)
    }

    public func parse(schema: SchemaObjectNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> DataModel.Possible {
        // got media type schema
        // it can be ref or in-place declaration
        // in-place declaration is unsupported
        switch schema.next {
        case .object:
            throw CustomError(message: "MediaType shouldn't contains object definition. Only refs (and arr with refs) supported")
        case .enum:
            throw CustomError(message: "MediaType shouldn't contains enum definition. Only refs (and arr with refs) supported")
        case .simple:
            throw CustomError(message: "MediaType shouldn't contains alias definition. Only refs (and arr with refs) supported")
        case .array(let val):
            let parsed = try self.arrayParser.parse(array: val, current: current, other: other)
            return .array(parsed)
        case .reference(let val):
            return try self.parse(ref: val, current: current, other: other)
        case .group(let val):
            throw CustomError.notInplemented()
        }
    }

    func parse(ref: String, current: DependencyWithTree, other: [DependencyWithTree]) throws -> DataModel.Possible {
        let schemaType = try wrap(
            Resolver().resolveSchema(ref: ref, node: current, other: other),
            message: "While resolving \(ref) at file \(current.dependency.pathToCurrentFile)"
        )

        // if resolving works then we should  check that response or request contains object
        // we just don't know what we should deal with plain entites

        switch schemaType {
        case .alias:
            throw CustomError(message: "MediaType shouldn't contains ref on alias. Only objects are supported")
        case .enum:
            throw CustomError(message: "MediaType shouldn't contains ref on enum. Only objects are supported")
        case .object(let val):
            return .object(val)
        case .array(let val):
            return .array(val)
        }
    }
}
