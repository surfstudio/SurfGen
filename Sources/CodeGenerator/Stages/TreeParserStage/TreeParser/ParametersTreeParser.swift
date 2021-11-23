//
//  ParametersTreeParser.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation
import GASTTree
import Common

public struct ParametersTreeParser {

    public let array: ArrayParser

    private let resolver: Resolver

    public init(array: ArrayParser, resolver: Resolver) {
        self.array = array
        self.resolver = resolver
    }

    public func parse(parameter: Referenced<ParameterNode>, current: DependencyWithTree, other: [DependencyWithTree]) throws -> Reference<ParameterModel> {
        switch parameter {
        case .entity(let paramNode):
            return .notReference(try self.parse(parameter: paramNode, current: current, other: other))
        case .ref(let ref):
            return .reference(try resolver.resolveParameter(ref: ref, node: current, other: other))
        }
    }

    func parse(parameter: ParameterNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> ParameterModel {

        let type = try wrap(
            self.parse(schema: parameter.type.schema, current: current, other: other),
            message: "While parsing parameter \(parameter.name)"
        )

        return .init(componentName: parameter.componentName,
                     name: parameter.name,
                     location: parameter.location,
                     type: type,
                     description: parameter.description,
                     isRequired: parameter.isRequired)
    }

    private func parse(schema: SchemaObjectNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> ParameterModel.PossibleType {
        switch schema.next {
        case .object(let val):
            throw CommonError(message: "Parameters's type must not contains `object` definition, but it contains \(val)")
        case .enum(let val):
            throw CommonError(message: "Parameters's type must not contains `enum` definition, but it contains \(val)")
        case .group(let val):
            throw CommonError(message: "Parameters's type must not contains `group` definition, but it contains \(val)")
        case .simple(let primitive):
            // TODO: - At this place we ignore definition of alias inside parameter
            // so idk if we need it.
            return .primitive(primitive.type)
        case .reference(let ref):
            return .reference(try resolver.resolveSchema(ref: ref, node: current, other: other))
        case .array(let val):
            let arr = try self.array.parse(array: val, current: current, other: other)
            return .array(arr)
        }
    }
}
