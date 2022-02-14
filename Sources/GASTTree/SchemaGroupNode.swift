//
//  File.swift
//  
//
//  Created by Александр Кравченков on 29.12.2020.
//

import Foundation

/// This object represents `oneOf`, `allOf` and `anyOf` keywords
public struct SchemaGroupNode {

    public let name: String
    public let references: [String]
    public let type: SchemaGroupType
    public let apiDefinitionFileRef: String

    public init(
        name: String,
        references: [String],
        type: SchemaGroupType,
        apiDefinitionFileRef: String
    ) {
        self.name = name
        self.references = references
        self.type = type
        self.apiDefinitionFileRef = apiDefinitionFileRef
    }
}
