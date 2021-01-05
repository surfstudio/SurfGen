//
//  SchemaEnumModel.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation
import GASTTree

/// Describes enum declration with cases.
///
/// ```YAML
///
/// components:
///     schemas:
///         MyEnum:
///             type: string
///             enum: ['one', 'two', 'tree', 'and more']
/// ```
///
/// Can be only primitive.
///
/// _and please, don't create bool enums_ (:
///
/// ## Serialization schema
///
/// ```YAML
/// SchemaEnumModel:
///     type: object
///     prperties:
///         name:
///             type: string
///         cases:
///             type: array
///             items:
///                 type: string
///         type:
///             description: Property's type
///             type:
///                 $ref: "primitive_type.yaml#/components/schemas/PrimitiveType"
/// ```
public struct SchemaEnumModel: Encodable {
    public let name: String
    public let cases: [String]
    public let type: PrimitiveType
}
