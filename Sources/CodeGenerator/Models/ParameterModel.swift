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
    /// Parameter name (as name in URI)
    ///
    /// For `projectId` it will be `projectId`
    public let name: String
    /// Place where parameter must be set
    public let location: ParameterNode.Location
    public let type: PossibleType
    public let description: String?
    public let isRequired: Bool

    /// This value will be used as type for generation
    let typeName: String
    let isTypeArray: Bool
    /// True if type is a ref to model or array with ref to model
    let isTypeObject: Bool

    init(componentName: String?,
         name: String,
         location: ParameterNode.Location,
         type: ParameterModel.PossibleType,
         description: String?,
         isRequired: Bool) {
        self.componentName = componentName
        self.name = name
        self.location = location
        self.type = type
        self.description = description
        self.isRequired = isRequired

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

extension ParameterModel.PossibleType {

    var isArray: Bool {
        if case .array = self {
            return true
        }
        return false
    }

    var isObject: Bool {
        switch self {
        case .array(let array):
            return array.itemsType.isObject
        case .primitive:
            return false
        case .reference(let schema):
            return schema.isObject
        }
    }
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
