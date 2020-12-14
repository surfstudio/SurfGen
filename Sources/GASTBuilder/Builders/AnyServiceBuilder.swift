//
//  AnyServiceBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Common
import Swagger

public protocol ServiceBuilder {
    func build(paths: [Path]) throws -> [PathNode]
}

public struct AnyServiceBuilder: ServiceBuilder {

    let parameterBuilder: ParametersBuilder

    public init(parameterBuilder: ParametersBuilder) {
        self.parameterBuilder = parameterBuilder
    }

    public func build(paths: [Path]) throws -> [PathNode] {
        return try paths.map { path in
            let operations = try wrap(self.build(operations: path.operations),
                                      message: "While parsing Path: \(path)")
            return PathNode(path: path.path, operations: operations)
        }
    }
}

extension AnyServiceBuilder {
    func build(operations: [Swagger.Operation]) throws -> [OperationNode] {
        return try operations.map { operation in

            let mapper = { (param: PossibleReference<Parameter>) -> Referenced<ParameterNode> in
                switch param {
                case .reference(let ref):
                    return .ref(ref.rawValue)
                case .value(let val):
                    let params = try wrap(
                        self.parameterBuilder.build(parameters: [.init(name: val.name, value: val)]),
                        message: "While parsing operation's parameter \(val.name)")

                    guard params.count == 1 else {
                        throw CustomError(message: "We had sent 1 parameter, and then got \(params.count). It's very strange. Plz contact mainteiners")
                    }

                    return .entity(params[0])
                }
            }

            let params = try wrap(operation.parameters.map(mapper),
                                  message: "While parsing operation \(operation.method.rawValue)")

            return .init(method: operation.method.rawValue,
                         description: operation.description,
                         summary: operation.summary,
                         parameters: params)
        }
    }
}
