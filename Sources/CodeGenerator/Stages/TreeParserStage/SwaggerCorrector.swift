//
//  SwaggerCorrector.swift
//  
//
//  Created by Dmitry Demyanov on 02.02.2021.
//

import Foundation
import Common

/// This class keeps logic of determining if passed elements are correct in terms of OpenAPI Specification
/// It can also fix some of detected issues
/// All found issues are passed to the Logger
public class SwaggerCorrector {

    private let logger: Loger?

    /// Works silently, without making warnings, if no `Logger` passed
    public init(logger: Loger? = nil) {
        self.logger = logger
    }

    /// Checks that `path` doesn't contain query string paramters
    /// If it does, removes them
    /// See https://swagger.io/docs/specification/paths-and-operations/#query-string-in-paths for details
    /// See `SwaggerCorrectorTests` for example
    public func correctPath(_ path: String) -> String {
        // Query string in URL (if exists) follows "?" like `example.com/users?role=admin`
        if let questionMarkIndex = path.range(of: "?")?.lowerBound {
            logger?.warning("Path \(path) should not contain query string. Trying to fix...")
            return String(path.prefix(upTo: questionMarkIndex))
        }

        return path
    }

    /// Checks that `path` parameters are declared in `Path`, but not in `Operation`
    /// If some are declared in `Operation`, gives warning and tries to fix it
    /// See `ParameterTests` for details
    /// See `SwaggerCorrectorTests` for example
    public func correctPathParameters(for pathModel: PathModel) -> [Reference<ParameterModel>] {
        let pathParameterNames = pathModel.parameters.map { $0.value.name }

        for operation in pathModel.operations {
            let operationPathParameters = operation.parameters?.filter { $0.value.location == .path } ?? []
            let operationOnlyPathParameters = operationPathParameters.filter { !pathParameterNames.contains($0.value.name) }

            guard operationOnlyPathParameters.isEmpty else {
                for parameter in operationOnlyPathParameters {
                    logger?.warning("Parameter \(parameter.value.name) for path \(pathModel.path) is declared inside Operation. Path parameters should be declared inside Path. Trying to fix...")
                }
                return operationPathParameters
            }
        }
        return pathModel.parameters
    }

}
