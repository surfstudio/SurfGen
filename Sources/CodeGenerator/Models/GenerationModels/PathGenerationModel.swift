//
//  PathGenerationModel.swift
//  
//
//  Created by Александр Кравченков on 19.10.2021.
//

import Foundation

/// Model for code generator
/// Based on `PathModel`
public struct PathGenerationModel: Encodable {

    public let path: String
    public let operations: [OperationGenerationModel]

    public var name: String
    public let pathWithSeparatedParameters: String
    public let parameters: [ParameterModel]

    public init(pathModel: PathModel) {
        self.path = pathModel.path
        self.operations = pathModel.operations
            .sorted { $0.httpMethod < $1.httpMethod }
            .map { OperationGenerationModel(operationModel: $0) }
        self.name = pathModel.path.pathName
        self.pathWithSeparatedParameters = pathModel.path.pathWithSeparatedParameters
        self.parameters = pathModel.parameters.map { $0.value }
    }

}

extension PathGenerationModel {

    var codingKeys: [String] {
        return operations.flatMap { $0.codingKeys }
    }
}
