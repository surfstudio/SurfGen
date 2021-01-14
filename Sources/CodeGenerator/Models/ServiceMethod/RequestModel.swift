//
//  RequestModel.swift
//  
//
//  Created by Александр Кравченков on 05.01.2021.
//

import Foundation
import GASTTree

/// Describes `request body` part of API method
///
/// ```YAML
/// components:
///     requestBodies:
///         ServiceStatus:
///             content:
///                 "application/json":
///                     schema:
///                         $ref: "models.yaml#/components/schemas/ServiceStatus"
/// ```
///
/// ## Serialization schema
///
/// ```YAML
/// RequestModel:
///     type: object
///     properties:
///         description:
///             type: string
///         isRequired:
///             type: boolean
///         content:
///             type: array
///             items:
///                 $ref: "data_model.yaml#/components/schemas/DataModel"
/// ```
public struct RequestModel: Encodable {
    /// Description which was proided (or not) in specification
    public let description: String?
    public let content: [DataModel]
    public let isRequired: Bool
}
