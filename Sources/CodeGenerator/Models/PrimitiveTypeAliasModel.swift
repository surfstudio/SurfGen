//
//  PrimitiveTypeAliasModel.swift
//  
//
//  Created by Александр Кравченков on 26.12.2020.
//

import Foundation
import GASTTree

/// Describes alias. Or named primitive type
///
/// For example:
///
/// ```YAML
/// components:
///     schemas:
///         UserID:
///             type: string
/// ```
///
/// Can only be `primitive`
///
/// ## Serialization schema
///
/// ```YAML
/// PrimitiveTypeAliasModel:
///     type: object
///     properties:
///         name:
///             type: string
///         type:
///             $ref: "primitive_type.yaml#/components/schemas/PrimitiveType"
/// ```
public struct PrimitiveTypeAliasModel: Encodable {

    /// Component's name.
    /// For example above it will be `userID`
    public let name: String
    public let type: PrimitiveType

    public init(name: String, type: PrimitiveType) {
        self.name = name
        self.type = type
    }
}
