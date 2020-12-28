//
//  PropertyModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

public struct PropertyModel {

    public indirect enum PossibleType {
        case primitive(PrimitiveType)
        case reference(SchemaType)
        case array(PossibleType)
    }

    public let name: String
    public let description: String?
    public let type: PossibleType
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
        case .reference(let ref):
            try container.encode(ref, forKey: .value)
        case .array(let arr):
            try container.encode(arr, forKey: .value)
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
            return "primitive"
        case .reference:
            return "reference"
        case .array:
            return "array"
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
