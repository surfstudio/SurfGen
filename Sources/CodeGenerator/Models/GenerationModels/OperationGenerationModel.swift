//
//  OperationGenerationModel.swift
//  
//
//  Created by Александр Кравченков on 19.10.2021.
//

import Foundation

/// Model for code generator
/// Based on `OperationModel`
///
/// /// ## Serialization schema
///
/// ```YAML
///
/// OperationModel:
///     type: object
///     properties:
///         httpMethod:
///             type: string
///         description:
///             type: string
///             nullable: true
///         pathParameters:
///             nullable: true
///             type: array
///             items:
///                 $ref: "#components/schemas/ParameterModel"
///         queryParameters:
///             nullable: true
///             type: array
///             items:
///                 $ref: "#components/schemas/ParameterModel"
///         requestGenerationModel:
///             nullable: true
///             type: array
///             items:
///                 $ref: "#components/schemas/DataGenerationModel"
///         responseGenerationModel:
///             nullable: true
///             type:
///                 $ref: "#components/schemas/DataGenerationModel"
/// ```
public struct OperationGenerationModel: Encodable {

    public struct Keyed<T: Encodable>: Encodable {
        let key: String
        let value: T?
    }

    /// http method string representation
    ///
    /// For example `GET`
    public let httpMethod: String
    /// Short summary of what the operation does
    public let summary: String?
    /// Verbose explanation of the operation behavior
    public let description: String?
    /// Path and query parameters of specific operations
    public let parameters: [Reference<ParameterModel>]?
    public let responses: [Reference<ResponseModel>]?
    public let requestModel: Reference<RequestModel>?

    public let pathParameters: [ParameterModel]
    public let queryParameters: [ParameterModel]
    public let requestGenerationModel: DataGenerationModel?
    public let responseGenerationModel: Keyed<DataGenerationModel>?

    public let allGenerationResponses: [ResponseGenerationModel]?

    init(operationModel: OperationModel) {
        self.httpMethod = operationModel.httpMethod
        self.summary = operationModel.summary

        self.description = operationModel.description
        self.parameters = operationModel.parameters
        self.responses = operationModel.responses
        self.requestModel = operationModel.requestModel

        let allParameters = (operationModel.parameters ?? [])
            .map { $0.value }
            .sorted { $0.name < $1.name }
        self.pathParameters = allParameters.filter { $0.location == .path }
        self.queryParameters = allParameters.filter { $0.location == .query }

        let request = operationModel.requestModel?.value
        self.requestGenerationModel = request?.content.first.map {
            DataGenerationModel(dataModel: $0, isRequired: request?.isRequired ?? true)
        }

        let response = operationModel.responses?.first { $0.value.key.isSuccessStatusCode }?.value

        if let response = response {
            self.responseGenerationModel = .init(
                key: response.key,
                value: response.values.first.map { DataGenerationModel(dataModel: $0) }
            )
        } else {
            self.responseGenerationModel = nil
        }

        self.allGenerationResponses = self.responses?
            .map { $0.value }
            .map { response in
                ResponseGenerationModel(
                    key: response.key,
                    responses: response.values.map { DataGenerationModel(dataModel: $0) }
                )
            }
    }
}

extension OperationGenerationModel {

    var codingKeys: [String] {
        return queryParameters.map { $0.name }
    }

}
