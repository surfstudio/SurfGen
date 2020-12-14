//
//  AnyParametersBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Common
import Swagger

public protocol ParametersBuilder {
    func build(parameters: [ComponentObject<Parameter>]) throws -> [ParameterNode]
}

public struct AnyParametersBuilder: ParametersBuilder {

    public func build(parameters: [ComponentObject<Parameter>]) throws -> [ParameterNode] {

        return try parameters.map { parameter -> ParameterNode in

            let loc = try wrap(parameter.value.location.convert(),
                           message: "While parsing parameter \(parameter.name)")

            let type = try wrap(self.parse(type: parameter.value.type),
                                message: "While parsing parameter \(parameter.name)")

            return ParameterNode(name: parameter.name,
                                 location: loc,
                                 description: parameter.value.description,
                                 type: type,
                                 isRequired: parameter.value.required)
        }
    }
}

extension AnyParametersBuilder {

    private func parse(type: ParameterType) throws -> ParameterTypeNode {
        switch type {
        case .content:
            throw CustomError(message: "We don't support `content` parameter's type")
        case .schema(let schema):
            return .init(schema: try ParametersSchemaBuilder().build(schema: schema))
        }
    }
}
