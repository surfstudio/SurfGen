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
public struct PathModel: Encodable {
    /// URI template
    public let path: String
    public let apiDefinitionFileRef: String
    public let operations: [OperationModel]

    public init(path: String, operations: [OperationModel], apiDefinitionFileRef: String) {
        self.path = path
        self.operations = operations.sorted { $0.httpMethod < $1.httpMethod }
        self.apiDefinitionFileRef = apiDefinitionFileRef
    }
    
}
