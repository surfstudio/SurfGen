//
//  ParameterModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

/// Method's URI parameter
///
/// For example URI `https://ex.com/projects/{projectId}/user?name={userName}`
///
/// contains 2 parameters:
/// - projectId - `Path parameter`
/// - userName - `Query parameter`
///
/// Of course parameters have type.
///
/// And it may be one of:
/// - `PrimitiveType` - `primitive`
/// - `SchemaType` - `reference`
/// - `SchemaArrayModel` - `array`
///
/// ## Serialization schema
///
/// ```YAML
/// Type:
///     type: string
///     enum: ['primitive', 'reference', 'array']
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
///                         - $ref: "primitive_type.yaml#/component/schemas/PrimitiveType"
///                         - $ref: "schema_type.yaml#/component/schemas/SchemaType"
///                         - $ref: "schema_array_model.yaml#/component/schemas/SchemaArrayModel"
///
/// ParameterModel:
///     type: object
///     properties:
///         componentName:
///             type: string
///             nullable: true
///         name:
///             type: string
///         location:
///             type:
///                 $ref: "#/components/schemas/Location"
///         type:
///             type:
///                 $ref: "#/components/schemas/PossibleType"
///         description:
///             type: string
///             nullable: true
///         isRequired:
///             type: boolean
/// ```
public struct ParameterModel: Encodable {

    public enum PossibleType {
        case primitive(PrimitiveType)
        case reference(SchemaType)
        case array(SchemaArrayModel)
    }

    /// Parameter can be declared both inside operation
    /// and separately of method definition.
    ///
    /// So if parameter was declared separately this field will set
    /// For `OpenAPI` it's component name
    ///
    /// For example:
    ///
    /// ```YAML
    /// components:
    ///     parameters:
    ///         MyParamComponentName:
    ///             name: projectId
    ///             in: path
    ///             shema:
    ///                 type: integer
    /// ```
    ///
    /// For this case `componentName` will be set to `MyParamComponentName`
    public let componentName: String?
    /// Parametr name (as name in URI)
    ///
    /// For `projectId` it will be `projectId`
    public let name: String
    /// Place where parameter must be set
    public let location: ParameterNode.Location
    public let type: PossibleType
    public let description: String?
    public let isRequired: Bool
}

extension ParameterModel.PossibleType: Encodable {

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
        case .array(let val):
            try container.encode(Constants.arrayTypeName, forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }
}

extension ParameterNode.Location: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .query:
            try container.encode("query")
        case .path:
            try container.encode("path")
        }
    }
}
