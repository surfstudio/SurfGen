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

    public init() { }

    public func parse(parameter: Referenced<ParameterNode>, current: DependencyWithTree, other: [DependencyWithTree]) throws -> Reference<ParameterModel, ParameterModel> {
        switch parameter {
        case .entity(let paramNode):
            return .notReference(try self.parse(parameter: paramNode, current: current, other: other))
        case .ref(let ref):
            return .reference(try Resolver().resolveParameter(ref: ref, node: current, other: other))
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
            throw CustomError(message: "Parameters's type must not contains `object` definition, but it contains \(val)")
        case .enum(let val):
            throw CustomError(message: "Parameters's type must not contains `enum` definition, but it contains \(val)")
        case .simple(let primitive):
            // TODO: - At this place we ignore definition of alias inside parameter
            // so idk if we need it.
            return .primitive(primitive.type)
        case .reference(let ref):
            return .reference(try Resolver().resolveSchema(ref: ref, node: current, other: other))
        }
    }
}
