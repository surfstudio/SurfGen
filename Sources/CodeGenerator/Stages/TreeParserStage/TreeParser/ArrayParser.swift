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
               other: [DependencyWithTree]) throws -> SchemaArrayModel.PossibleType

    func parse(array: SchemaArrayNode,
               current: DependencyWithTree,
               other: [DependencyWithTree]) throws -> SchemaArrayModel
}

public struct AnyArrayParser: ArrayParser {

    private let resolver: Resolver

    public init(resolver: Resolver) {
        self.resolver = resolver
    }

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
                      other: [DependencyWithTree]) throws -> SchemaArrayModel.PossibleType {

        switch schema.next {
        case .object:
            throw CommonError(message: "Array shouldn't contains object definition")
        case .enum:
            throw CommonError(message: "Array shouldn't contains object definition")
        case .group:
            throw CommonError(message: "Array shouldn't contains group definition")
        case .simple(let val):
            return .primitive(val.type)
        case .reference(let val):
            let schemaType = try wrap(
                resolver.resolveSchema(ref: val, node: current, other: other),
                message: "While resolving \(val) at file \(current.dependency.pathToCurrentFile)"
            )

            return .reference(schemaType)
        case .array:
            throw CommonError(message: "Array shouldn't contains array definition")
        }
    }
}
