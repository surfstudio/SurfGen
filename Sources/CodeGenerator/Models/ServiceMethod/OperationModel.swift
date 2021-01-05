//
//  OperationModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

/// Describes an API method
/// Operation it's specific CRUD method.
///
/// For example if we have method with uri: `www.example.com/projects/users`
/// So this method can be `GET /projects/users` for reading information
/// Or it may be `POST /projects/users` to create new user for projects
///
/// And each of that (`GET` and `POST`) will be different `OperationModel`
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
    /// For example `GET`
    public let httpMethod: String
    /// Description which was proided (or not) in specification
    public let description: String?
    /// Path and query parameters of specific operations
    public let parameters: [Reference<ParameterModel>]?
    public let responses: [Reference<ResponseModel>]?
    public let requestModel: Reference<RequestModel>?
}
