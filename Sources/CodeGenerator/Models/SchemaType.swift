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
public enum SchemaType {
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
    /// Entity which `type` property is `object`
    case object(SchemaObjectModel)
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
            try container.encode("alias", forKey: .type)
            try container.encode(val, forKey: .value)
        case .enum(let val):
            try container.encode("enum", forKey: .type)
            try container.encode(val, forKey: .value)
        case .object(let val):
            try container.encode("object", forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }


}
