//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree
import Common

// WRANING
//
// NotImplemented:
//
//  - Request/Response in OperationNode

public struct TreeParser {

    public func parse(tree: [String: RootNode]) throws -> [[ServiceModel]] {
        let mapper = { (key: String, value: RootNode) throws -> [ServiceModel] in
            return try wrap(
                self.parse(node: value, file: key, other: tree),
                message: "While parsing tree from file \(key)"
            )
        }

        let res = try tree.map(mapper)

        return res
    }

    func parse(node: RootNode, file: String, other: [String: RootNode]) throws -> [ServiceModel] {

        let mapper = { (service: PathNode) throws -> ServiceModel in
            return try wrap(
                self.parse(service: service, other: other),
                message: "While parsing service at path \(service.path)"
            )
        }

        let services = try node.services.map(mapper)

        return services
    }

    func parse(service: PathNode, other: [String: RootNode]) throws -> ServiceModel {

        let mapper = { (operation: OperationNode) throws -> OperationModel in
            return try wrap(
                self.parse(operation: operation, other: other),
                message: "While parsing operation \(operation.method)"
            )
        }

        let operations = try service.operations.map(mapper)

        return .init(path: service.path, operations: operations)
    }

    func parse(operation: OperationNode, other: [String: RootNode]) throws -> OperationModel {

        let params = try operation.parameters.map { parameter -> Reference<ParameterModel, ParameterModel> in
            switch parameter {
            case .entity(let paramNode):
                return .notReference(try self.parse(parameter: paramNode, other: other))
            case .ref(let ref):
                throw CustomError.notInplemented()
            }
        }

        return .init(
            httpMethod: operation.method,
            description: operation.description,
            parameters: params,
            responseModel: nil,
            requestModel: nil
        )
    }

    func parse(parameter: ParameterNode, other: [String: RootNode]) throws -> ParameterModel {

        let type = try wrap(
            self.parse(schema: parameter.type.schema, other: other),
            message: "While parsing parameter \(parameter.name)"
        )

        return .init(
            name: parameter.name,
            location: parameter.location,
            type: type,
            description: parameter.description,
            isRequired: parameter.isRequired
        )
    }

    func parse(schema: SchemaObjectNode, other: [String: RootNode]) throws -> TypeModel {
        switch schema.next {
        case .object(let obj):
            throw CustomError.notInplemented()
        case .enum(let `enum`):
            throw CustomError.notInplemented()
        case .simple(let primitive):
            return .primitive(primitive.rawValue)
        case .reference(let ref):
            throw CustomError.notInplemented()
        }
    }
}
