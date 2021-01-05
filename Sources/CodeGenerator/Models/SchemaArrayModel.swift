//
//  SchemaArrayModel.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import GASTTree

/// Describes array
///
/// ```YAML
///     BasketItem:
///        type: object
///        properties:
///          itemIds:
///            type: array      # <-- That's our SchemaArrayModel
///            items:
///              type: integer
/// ```
///
/// ## Serialization schema
///
/// ```YAML
///
/// Type:
///     type: string
///     enum: ['primitive', 'reference']
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
///                         - $ref: "schema_type.yaml#/component/schemas/SchemaType"      # <-- `Type.reference`
///
/// SchemaArrayModel:
///     type: object
///     prperties:
///         name:
///             type: string
///         itemsType:
///             description: Property's type
///             type:
///                 $ref: "#/components/schemas/PossibleType"
/// ```
public struct SchemaArrayModel: Encodable {

    public enum PossibleType {
        case primitive(PrimitiveType)
        case reference(SchemaType)
    }

    /// For arrays decalred in-lace this field will be empty
    public var name: String
    public var itemsType: PossibleType

    public init(name: String, itemsType: PossibleType) {
        self.name = name
        self.itemsType = itemsType
    }
}

extension SchemaArrayModel.PossibleType: Encodable {

    enum Keys: String, CodingKey {
        case type = "type"
        case value = "value"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        switch self {
        case .primitive(let val):
            try container.encode(Constants.primitiveTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        case .reference(let val):
            try container.encode(Constants.referenceTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }
}
