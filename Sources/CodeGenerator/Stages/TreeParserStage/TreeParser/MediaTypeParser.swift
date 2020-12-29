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

    public init() { }

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
        case .reference(let val):
            let schemaType = try wrap(
                Resolver().resolveSchema(ref: val, node: current, other: other),
                message: "While resolving \(val) at file \(current.dependency.pathToCurrentFile)"
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
        case .array(let val):
            let parsed = try self.parse(array: val, current: current, other: other)
            return .array(parsed)
        }
    }

    public func parse(array: SchemaArrayNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> SchemaArrayModel {

        let val = try wrap(
            self.parseForArray(schema: array.type, current: current, other: other),
            message: "While parsing array \(array.name)"
        )

        return .init(name: array.name, itemsType: val)
    }

    public func parseForArray(schema: SchemaObjectNode,
                              current: DependencyWithTree,
                              other: [DependencyWithTree]) throws -> SchemaArrayModel.Possible {

        switch schema.next {
        case .object:
            throw CustomError(message: "Array shouldn't contains object definition")
        case .enum:
            throw CustomError(message: "Array shouldn't contains object definition")
        case .simple(let val):
            return .primitive(val.type)
        case .reference(let val):
            let schemaType = try wrap(
                Resolver().resolveSchema(ref: val, node: current, other: other),
                message: "While resolving \(val) at file \(current.dependency.pathToCurrentFile)"
            )

            return .reference(schemaType)
        case .array:
            throw CustomError(message: "Array shouldn't contains array definition")
        }
    }
}
