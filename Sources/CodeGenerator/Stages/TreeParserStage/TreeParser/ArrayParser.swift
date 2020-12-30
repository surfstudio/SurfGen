//
//  File.swift
//  
//
//  Created by Александр Кравченков on 29.12.2020.
//

import Foundation
import GASTTree
import Common

public protocol ArrayParser {
    func parse(schema: SchemaObjectNode,
               current: DependencyWithTree,
               other: [DependencyWithTree]) throws -> SchemaArrayModel.Possible

    func parse(array: SchemaArrayNode,
               current: DependencyWithTree,
               other: [DependencyWithTree]) throws -> SchemaArrayModel
}

public struct AnyArrayParser: ArrayParser {

    public init() { }

    public func parse(array: SchemaArrayNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> SchemaArrayModel {

        let val = try wrap(
            self.parse(schema: array.type, current: current, other: other),
            message: "While parsing array \(array.name)"
        )

        return .init(name: array.name, itemsType: val)
    }
    
    public func parse(schema: SchemaObjectNode,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> SchemaArrayModel.Possible {

        switch schema.next {
        case .object:
            throw CustomError(message: "Array shouldn't contains object definition")
        case .enum:
            throw CustomError(message: "Array shouldn't contains object definition")
        case .group:
            throw CustomError(message: "Array shouldn't contains group definition")
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
