//
//  ResponseModel.swift
//  
//
//  Created by Александр Кравченков on 05.01.2021.
//

import Foundation
import GASTTree

/// Describes specific response
///
/// ```YAML
/// components:
///     responses:
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
/// ResponseModel:
///     type: object
///     properties:
///         key:
///             type: string
///         values:
///             type: array
///             items:
///                 $ref: "data_model.yaml#/components/schemas/DataModel"
/// ```
public struct ResponseModel: Encodable {
    /// May be `statusCode` or `default` string
    public let key: String
    /// Possible results
    public let values: [DataModel]
}
