//
//  DataModel.swift
//  
//
//  Created by Александр Кравченков on 05.01.2021.
//

import Foundation
import GASTTree

/// Data which is used in `RequestModel` and `ResponseModel`
///
/// Can be:
/// - `SchemaObjectModel` or `object`
/// - `SchemaArrayModel` or `array`
/// - `SchemaGroupModel` or `group`
///
/// ## Serialization schema
///
/// ```YAML
/// Type:
///     type: string
///     enum: ['object', 'array', 'group']
///
/// Location:
///     type: string
///     enum: ['query', 'path']
///
/// PossibleType:
///     type: object
///     properties:
///         type:
///             description: String description of vaue's type
///             type:
///                 $ref: "#/components/schemas/Type"
///         value:
///             type:
///                 schema:
///                     oneOf:
///                         - $ref: "schema_object_model.yaml#/component/schemas/SchemaObjectModel"
///                         - $ref: "schema_array_model.yaml#/component/schemas/SchemaArrayModel"
///                         - $ref: "schema_group_model.yaml#/component/schemas/SchemaGroupModel"
///
/// DataModel:
///     type: object
///     properties:
///         mediaType:
///             type: string
///         type:
///             type:
///                 $ref: "#/components/schemas/PossibleType"
/// ```
public struct DataModel: Encodable {

    /// Possibe API entities which can be used in this model
    public enum PossibleType {
        case object(SchemaObjectModel)
        case array(SchemaArrayModel)
        case group(SchemaGroupModel)
    }

    /// Media-Type value
    ///
    /// For example:
    ///
    /// ```
    /// application/json
    /// ```
    public let mediaType: String
    public let type: PossibleType

    public init(mediaType: String, type: PossibleType) {
        self.mediaType = mediaType
        self.type = type
    }
}

extension DataModel.PossibleType {

    var name: String {
        switch self {
        case .object(let object):
            return object.name
        case .array(let array):
            return array.itemsType.name
        case .group(let group):
            return group.name
        }
    }

    var isArray: Bool {
        if case .array = self {
            return true
        }
        return false
    }

    var isObject: Bool {
        switch self {
        case .object:
            return true
        case .array(let array):
            return array.itemsType.isObject
        case .group:
            return false
        }
    }
}

extension DataModel.PossibleType: Encodable {

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
        case .array(let val):
            try container.encode(Constants.arrayTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        case .group(let val):
            try container.encode(Constants.groupTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }
}
