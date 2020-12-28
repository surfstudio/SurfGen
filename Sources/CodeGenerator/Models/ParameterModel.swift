//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

public struct ParameterModel {

    public enum PossibleType {
        case primitive(PrimitiveType)
        case reference(SchemaType)
    }

    // this name is set when the parameter was declared in `components`
    public let componentName: String?
    public let name: String
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
            try container.encode("primitive", forKey: .type)
            try container.encode(val, forKey: .value)
        case .reference(let val):
            try container.encode("reference", forKey: .type)
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

extension ParameterModel: Encodable { }
