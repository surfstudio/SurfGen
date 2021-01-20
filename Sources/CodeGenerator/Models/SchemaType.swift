//
//  SchemaType.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation
import GASTTree

/// This is the enumeration of possible schema object
///
/// It's about entities that is written in `schemas:` part
/// In terms of this comments any items which is encluded in `schemas:` part is called `entity`
///
/// ## Serialization schema
///
/// ```YAML
///
/// Type:
///     type: string
///     enum: ['alias', 'enum', 'object', 'array', 'group']
///
/// SchemaType:
///     type: object
///     prperties:
///         name:
///             type: string
///         type:
///             type:
///                 $ref: "#/components/schemas/Type"
///         value:
///             type:
///                 oneOf:
///                     - $ref: "primitive_type_alias_model.yaml#/components/schemas/PrimitiveTypeAliasModel"
///                     - $ref: "schema_enum_model.yaml#/components/schemas/SchemaEnumModel"
///                     - $ref: "schema_object_model.yaml#/components/schemas/SchemaObjectModel"
///                     - $ref: "schema_array_model.yaml#/components/schemas/SchemaArrayModel"
///                     - $ref: "schema_group_model.yaml#/components/schemas/SchemaGroupModel"
/// ```
public indirect enum SchemaType {
    /// Just a primitive type
    /// Schema which is primitive is just an alias
    ///
    /// For example:
    /// ```YAML
    ///schemas:
    ///     UserID:
    ///         type: string
    /// ```
    /// And `UserID` is just an alias on `String` type
    ///
    /// In Swift it would look like `typealias UserID = String`
    case alias(PrimitiveTypeAliasModel)
    /// It's an entity with `PrimitiveType` but it has property `enum`
    case `enum`(SchemaEnumModel)
    /// Entity whose `type` property is `object`
    case object(SchemaObjectModel)
    /// Entity whose type is `array`
    case array(SchemaArrayModel)
    /// It's about:
    ///
    ///```YAML
    ///schemas:
    /// GroupExample:
    ///     oneOf | allOf | anyOf:
    ///         - $ref: ".."
    ///         - $ref: ".."
    ///         ....
    ///```
    case group(SchemaGroupModel)

    var name: String {
        switch self {
        case .alias(let alias):
            return alias.name
        case .enum(let enumModel):
            return enumModel.name
        case .object(let object):
            return object.name
        case .array(let array):
            return array.typeName
        case .group(let group):
            return group.name
        }
    }
}

extension SchemaType: Encodable {

    enum Keys: String, CodingKey {
        case type = "type"
        case value = "value"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        switch self {
        case .alias(let val):
            try container.encode(Constants.aliasTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        case .enum(let val):
            try container.encode(Constants.enumTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
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
