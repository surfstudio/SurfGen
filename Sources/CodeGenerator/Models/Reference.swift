//
//  Reference.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation

/// Wrapper on type
/// In many elemnts of specifiation we may have `in-place` declaration
/// and `reference` declration
///
/// For example:
/// ```
/// components:
///     schemas:
///         InPlaceObject:
///             properties:
///                 field:
///                     type: integer # <-- This is `in-place` declaration
///
///         RefObject:
///             properties:
///                 field:
///                     $ref: "#components/schemas/InPlaceObject" # <-- This is `refernce` declaration
/// ```
///
/// `DataType` is a type of component (SchemaObject, Enum, etc.)
///
/// ## Serialization schema
///
/// ** WATCH OUT**
///
/// Each component serialization schema contains its own reference declaration. Because OpenAPI doesn't support generics
///
/// This declaration just an example.
///
/// ```YAML
/// ReferenceType:
///     type: object
///     properties:
///         isReference:
///             description: True if this is reference
///             type: bool
///         value:
///             description: Specific value. Enum, Object, e.t.c
///             type: Any
/// ```
public enum Reference<DataType> {
    case reference(DataType)
    case notReference(DataType)
}

extension Reference: Encodable where DataType: Encodable {

    enum CodingKeys: String, CodingKey {
        case isReference = "isReference"
        case value = "value"
    }

    var isReference: Bool {
        switch self {
        case .notReference:
            return false
        case .reference:
            return true
        }
    }

    var value: DataType {
        switch self {
        case .notReference(let val):
            return val
        case .reference(let val):
            return val
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isReference, forKey: .isReference)
        try container.encode(self.value, forKey: CodingKeys.value)
    }

}
