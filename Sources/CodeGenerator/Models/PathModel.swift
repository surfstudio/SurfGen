//
//  PathModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation

/// Describes path (or one `path`)
///
/// ```YAML
/// /billings/payment:
///   post:
///     parameters:
///       - name: smartCardOrAgreement
///         required: false
///         in: query
///         schema:
///           type: string
///     requestBody:
///       required: true
///       content:
///         application/json:
///           schema:
///             $ref: "models.yaml#/components/schemas/PaymentDetailsRequest"
///     responses:
///       "200":
///         content:
///           application/json:
///             schema:
///               $ref: "models.yaml#/components/schemas/PaymentDetailsResponse"
///   get:
///     responses:
///       "200":
///         content:
///           application/json:
///             schema:
///               $ref: "models.yaml#/components/schemas/UserContactInfo"
/// ```
///
/// ## Serialization schema
///
/// ```YAML
///
/// Type:
///     type: string
///     enum: ['object', 'group']
///
/// SchemaGroupType:
///     type: string
///     enum: ['oneOf', 'onyOf', 'allOf']
///
/// PossibleType:
///     type: object
///     properties:
///         type:
///             type:
///                 $ref: "#/components/schemas/Type"
///         value:
///             type:
///                 schema:
///                     oneOf:
///                         - $ref: "schema_object_model.yaml#/component/schemas/SchemaObjectModel"
///                         - $ref: "schema_group_model.yaml#/component/schemas/SchemaGroupModel"
///
/// PathModel:
///     type: object
///     prperties:
///         path:
///             type: string
///         operations:
///             type: array
///             items:
///                 $ref: "operation_model.yaml#/components/schemas/OperationModel"
/// ```
public struct PathModel: Encodable {
    /// URI template
    public let path: String
    public let operations: [OperationModel]

    let name: String
    let pathWithSeparatedParameters: String
    let parameters: [ParameterModel]

    init(path: String, operations: [OperationModel]) {
        self.path = path
        self.operations = operations
        self.name = path.pathName
        self.pathWithSeparatedParameters = path.pathWithSeparatedParameters
        self.parameters = operations[0].pathParameters
    }
    
}
