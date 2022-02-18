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
///         description:
///             type: string
///             nullable: true
/// ```
public struct SchemaEnumModel: Encodable {
    public let name: String
    public let cases: [String]
    public let type: PrimitiveType
    public let description: String?
    public let apiDefinitionFileRef: String

    /// This value will be used as type for generation
    public let generatedType: String

    init(name: String,
         cases: [String],
         type: PrimitiveType,
         description: String?,
         apiDefinitionFileRef: String
    ) {
        self.name = name
        self.cases = cases.sorted()
        self.type = type
        self.description = description
        self.generatedType = type.rawValue
        self.apiDefinitionFileRef = apiDefinitionFileRef
    }
}
