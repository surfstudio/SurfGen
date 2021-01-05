//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import GASTTree

public struct SchemaArrayModel {

    public enum Possible {
        case primitive(PrimitiveType)
        case reference(SchemaType)
    }

    public var name: String
    public var itemsType: Possible

    public init(name: String, itemsType: Possible) {
        self.name = name
        self.itemsType = itemsType
    }
}

extension SchemaArrayModel.Possible: Encodable {

    enum Keys: String, CodingKey {
        case type = "string"
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

extension SchemaArrayModel: Encodable { }
