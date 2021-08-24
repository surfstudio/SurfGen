//
//  OperationModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

/// Describes an API method
///
/// Operation it's specific CRUD method.
///
/// For example if we have method with uri: `www.example.com/projects/users`
///
/// this method can be `GET /projects/users` for reading information
///
/// Or it can be `POST /projects/users` to create new user for projectsэто
///
/// And each of those (`GET` and `POST`) will be a different `OperationModel`
///
/// ```YAML
/// /billings/payment:
///    post:
///      parameters:
///        - name: smartCardOrAgreement
///          required: false
///          in: query
///          schema:
///            type: string
///      requestBody:
///        required: true
///        content:
///          application/json:
///            schema:
///              $ref: "models.yaml#/components/schemas/PaymentDetailsRequest"
///      responses:
///        "200":
///          content:
///            application/json:
///              schema:
///                $ref: "models.yaml#/components/schemas/PaymentDetailsResponse"
/// ```
///
/// ## Serialization schema
///
/// ```YAML
///
/// ParametersRef:
///     type: object
///     properties:
///         isReference:
///             type: bool
///         value:
///             type:
///                 $ref: "parameter_model.yaml#/components/schemas/ParameterModel"
///
/// ResponseModelRef:
///     type: object
///     properties:
///         isReference:
///             type: bool
///         value:
///             type:
///                 $ref: "response_model.yaml#/components/schemas/ResponseModel"
///
/// RequestModelRef:
///     type: object
///     properties:
///         isReference:
///             type: bool
///         value:
///             type:
///                 $ref: "request_model.yaml#/components/schemas/RequestModel"
///
/// OperationModel:
///     type: object
///     properties:
///         httpMethod:
///             type: string
///         description:
///             type: string
///             nullable: true
///         parameters:
///             nullable: true
///             type: array
///             items:
///                 $ref: "#components/schemas/ParametersRef"
///         responses:
///             nullable: true
///             type: array
///             items:
///                 $ref: "#components/schemas/ResponseModelRef"
///         responses:
///             nullable: true
///             type:
///                 $ref: "#components/schemas/ResponseModelRef"
/// ```
public struct OperationModel: Encodable {

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

    let pathParameters: [ParameterModel]
    let queryParameters: [ParameterModel]
    let requestGenerationModel: DataGenerationModel?
    let responseGenerationModel: DataGenerationModel?

    init(httpMethod: String,
         summary: String?,
         description: String?,
         parameters: [Reference<ParameterModel>]?,
         responses: [Reference<ResponseModel>]?,
         requestModel: Reference<RequestModel>?) {
        self.httpMethod = httpMethod
        self.summary = summary
        
        self.description = description
        self.parameters = parameters
        self.responses = responses
        self.requestModel = requestModel

        let allParameters = (parameters ?? [])
            .map { $0.value }
            .sorted { $0.name < $1.name }
        self.pathParameters = allParameters.filter { $0.location == .path }
        self.queryParameters = allParameters.filter { $0.location == .query }

        let request = requestModel?.value.content.first
        self.requestGenerationModel = request.map { DataGenerationModel(dataModel: $0) }

        let response = responses?.first { $0.value.key.isSuccessStatusCode }?.value.values.first
        self.responseGenerationModel = response.map { DataGenerationModel(dataModel: $0) }
    }
}

extension OperationModel {

    var codingKeys: [String] {
        return queryParameters.map { $0.name }
    }
    
}
