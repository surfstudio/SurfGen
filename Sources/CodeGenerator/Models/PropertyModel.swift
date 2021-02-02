//
//  PropertyModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

/// Describes object's property
///
/// ```YAML
/// components:
///     schemas:
///         MyObject:
///             type: object
///             properties:
///                 field:
///                     type: integer
/// ```
///
/// So this object represents `field`
/// May be one of:
/// - `PrimitiveType` - `primitive`
/// - `SchemaType` - `reference`
/// - `array` which can be one of this enum (: (yah! recursion!)
///
/// ## Serialization schema
///
/// ```YAML
///
/// Type:
///     type: string
///     enum: ['primitive', 'reference', 'array']
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
///                         - $ref: "primitive_type.yaml#/component/schemas/PrimitiveType"
///                         - $ref: "schema_type.yaml#/component/schemas/SchemaType"
///                         - $ref: "schema_array_model.yaml#/component/schemas/SchemaArrayModel"
///
/// PropertyModel:
///     type: object
///     prperties:
///         name:
///             description: Propery name
///             type: string
///         description:
///             description: Proprty's description form specification
///             type: string
///             nullable: true
///         type:
///             description: Property's type
///             type:
///                 $ref: "#/components/schemas/PossibleType"
///         isNullable:
///             description: True if property can have null value
///             type: boolean
/// ```
public struct PropertyModel {

    public enum PossibleType {
        case primitive(PrimitiveType)
        case reference(SchemaType)
        case array(SchemaArrayModel)
    }

    public let name: String
    public let description: String?
    public let type: PossibleType
    public let isNullable: Bool

    /// This value will be used as type for generation
    let typeName: String
    let isTypeArray: Bool
    let isTypeObject: Bool

    init(name: String,
         description: String?,
         type: PropertyModel.PossibleType,
         isNullable: Bool) {
        self.name = name
        self.description = description
        self.type = type
        self.isNullable = isNullable

        switch type {
        case .array(let array):
            self.typeName = array.itemsType.name
        case .primitive(let type):
            self.typeName = type.rawValue
        case .reference(let schema):
            self.typeName = schema.name
        }
        self.isTypeArray = type.isArray
        self.isTypeObject = type.isObject
    }
}

extension PropertyModel.PossibleType {

    var isArray: Bool {
        if case .array = self {
            return true
        }
        return false
    }

    var isObject: Bool {
        switch self {
        case .array(let arrayModel):
            return arrayModel.itemsType.isObject
        case .primitive:
            return false
        case .reference(let schema):
            return schema.isObject
        }
    }
}


extension PropertyModel.PossibleType: Encodable {

    enum Keys: String, CodingKey {
        case type = "type"
        case value = "value"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        switch self {
        case .primitive(let primitive):
            try container.encode(primitive.rawValue, forKey: .value)
            try container.encode(Constants.primitiveTypeName, forKey: .type)
        case .reference(let ref):
            try container.encode(ref, forKey: .value)
            try container.encode(Constants.referenceTypeName, forKey: .type)
        case .array(let arr):
            try container.encode(arr, forKey: .value)
            try container.encode(Constants.arrayTypeName, forKey: .type)
        }
    }
}

extension PropertyModel: Encodable {

    enum Keys: String, CodingKey {
        case type = "type"
        case value = "value"
        case name = "name"
        case description = "description"
    }

    private var typeAsString: String {
        switch self.type {
        case .primitive:
            return Constants.primitiveTypeName
        case .reference:
            return Constants.referenceTypeName
        case .array:
            return Constants.arrayTypeName
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.typeAsString, forKey: .type)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)

        switch self.type {
        case .primitive(let primitive):
            try container.encode(primitive.rawValue, forKey: .value)
        case .reference(let ref):
            try container.encode(ref, forKey: .value)
        case .array(let arr):
            try container.encode(arr, forKey: .value)
        }
    }
}
