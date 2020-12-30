//
//  File.swift
//  
//
//  Created by Александр Кравченков on 29.12.2020.
//

import Foundation
import GASTTree

/// This object represents `oneOf`, `allOf` and `anyOf` keywords
public struct SchemaGroupModel {

    public enum Possible {
        case object(SchemaObjectModel)
        case group(SchemaGroupModel)
    }

    public let name: String
    public let references: [Possible]
    public let type: SchemaGroupType

    public init(name: String, references: [Possible], type: SchemaGroupType) {
        self.name = name
        self.references = references
        self.type = type
    }
}

extension SchemaGroupModel.Possible: Encodable {
    enum Keys: String, CodingKey {
        case type = "string"
        case value = "value"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        switch self {
        case .object(let val):
            try container.encode("object", forKey: .type)
            try container.encode(val, forKey: .value)
        case .group(let val):
            try container.encode("group", forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }
}

extension SchemaGroupType: Encodable { }
extension SchemaGroupModel: Encodable { }
