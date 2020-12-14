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
            let ops = try self.build(operations: path.operations)
            return PathNode(path: path.path, operations: ops)
        }
    }
}

extension AnyServiceBuilder {
    func build(operations: [Swagger.Operation]) throws -> [OperationNode] {
        return try operations.map { operation in

            let params = try operation.parameters.map{ param -> Referenced<ParameterNode> in
                switch param {
                case .reference(let ref):
                    return .ref(ref.rawValue)
                case .value(let val):
                    let params = try wrap(
                        self.parameterBuilder.build(parameters: [.init(name: val.name, value: val)]),
                        message: "While parsing operation's \(operation.method.rawValue) \(operation.path) parameter \(val.name)")

                    guard params.count == 1 else {
                        throw CustomError(message: "It's very strange. Plz contact mainteiners")
                    }

                    return .entity(params[0])
                }
            }

            return .init(method: operation.method.rawValue,
                         description: operation.description,
                         summary: operation.summary,
                         parameters: params)
        }
    }
}
