//
//  SchemaGroupModel.swift
//  
//
//  Created by Александр Кравченков on 29.12.2020.
//

import Foundation
import GASTTree

/// Represents `oneOf`, `allOf` and `anyOf` keywords
///
/// Can contains nested groups.
///
/// **WARNING**
///
/// This implementation can contains only references
///
/// _but, seriously, don't design your API like that_
///
/// ```YAML
/// components:
///     schemas:
///         MyGroup:
///             oneOf:
///                 - $ref: "models.yaml#/components/schemas/AuthRequest"
///                 - $ref: "models.yaml#/components/schemas/SilentAuthRequest"
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
/// SchemaGroupModel:
///     type: object
///     prperties:
///         name:
///             type: string
///         type:
///             type:
///                 $ref: "#/components/schemas/SchemaGroupType"
///         references:
///             type: array
///             items:
///                 $ref: "#/components/schemas/PossibleType"
/// ```
public struct SchemaGroupModel: Encodable {

    public enum PossibleType {
        case object(SchemaObjectModel)
        case group(SchemaGroupModel)
    }

    public let name: String
    public let references: [PossibleType]
    public let type: SchemaGroupType

    public init(name: String, references: [PossibleType], type: SchemaGroupType) {
        self.name = name
        self.references = references
        self.type = type
    }
}

extension SchemaGroupModel.PossibleType: Encodable {
    enum Keys: String, CodingKey {
        case type = "type"
        case value = "value"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        switch self {
        case .object(let val):
            try container.encode(Constants.objectTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        case .group(let val):
            try container.encode(Constants.groupTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }
}

extension SchemaGroupType: Encodable { }
