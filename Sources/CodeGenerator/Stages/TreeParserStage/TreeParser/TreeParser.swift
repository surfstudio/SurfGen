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

    let parametersParser = ParametersTreeParser()

    public func parse(trees: [DependencyWithTree]) throws -> [[ServiceModel]] {
        let mapper = { (tree: DependencyWithTree) throws -> [ServiceModel] in
            return try wrap(
                self.parse(tree: tree, other: trees),
                message: "While parsing tree from file \(tree.dependency.pathToCurrentFile)"
            )
        }

        let res = try trees.map(mapper)

        return res
    }

    func parse(tree: DependencyWithTree, other: [DependencyWithTree]) throws -> [ServiceModel] {

        let mapper = { (service: PathNode) throws -> ServiceModel in
            return try wrap(
                self.parse(service: service, current: tree, other: other),
                message: "While parsing service at path \(service.path)"
            )
        }

        let services = try tree.tree.services.map(mapper)

        return services
    }

    func parse(service: PathNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> ServiceModel {

        let mapper = { (operation: OperationNode) throws -> OperationModel in
            return try wrap(
                self.parse(operation: operation, current: current, other: other),
                message: "While parsing operation \(operation.method)"
            )
        }

        let operations = try service.operations.map(mapper)

        return .init(path: service.path, operations: operations)
    }

    func parse(operation: OperationNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> OperationModel {

        let params = try operation.parameters.map { parameter -> Reference<ParameterModel, ParameterModel> in
            
            return try wrap(
                self.parametersParser.parse(parameter: parameter, current: current, other: other),
                message: "While parsing parameter \(parameter.view)")
        }

        return .init(
            httpMethod: operation.method,
            description: operation.description,
            parameters: params,
            responseModel: nil,
            requestModel: nil
        )
    }
}
