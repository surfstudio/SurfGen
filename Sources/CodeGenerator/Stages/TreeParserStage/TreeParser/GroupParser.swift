//
//  File.swift
//  
//
//  Created by Александр Кравченков on 29.12.2020.
//

import Foundation
import Common
import GASTTree

public protocol GroupParser {
    func parse(group: SchemaGroupNode,
               current: DependencyWithTree,
               other: [DependencyWithTree]) throws -> SchemaGroupModel
}

public struct AnyGroupParser: GroupParser {

    public init() { }

    public func parse(group: SchemaGroupNode,
               current: DependencyWithTree,
               other: [DependencyWithTree]) throws -> SchemaGroupModel {

        let refs = try group.references.map {
            try self.parse(reference: $0, current: current, other: other)
        }

        return .init(name: group.name, references: refs, type: group.type)
    }

    func parse(reference: String,
               current: DependencyWithTree,
               other: [DependencyWithTree]) throws -> SchemaGroupModel.PossibleType {

        let resolved = try wrap(
            Resolver().resolveSchema(ref: reference, node: current, other: other),
            message: "While resolving \(reference) from \(current.dependency.pathToCurrentFile)"
        )

        switch resolved {
        case .alias:
            throw CommonError(message: "Group shouldn't contains references on aliases")
        case .enum:
            throw CommonError(message: "Group shouldn't contains references on enums")
        case .array:
            throw CommonError(message: "Group shouldn't contains references on arrays")
        case .object(let val):
            return .object(val)
        case .group(let val):
            return .group(val)
        }
    }
}
