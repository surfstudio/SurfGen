//
//  SchemaModelNode.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

/// Describes entity (Model)
/// It's object with name, properties, descriptions, e.t.c
///
/// So in terms of development it may be DTO
public struct SchemaModelNode {
    public let name: String
    public let properties: [PropertyNode]
    public let description: String?
    public let apiDefinitionFileRef: String

    public init(name: String,
                properties: [PropertyNode],
                description: String?,
                apiDefinitionFileRef: String
    ) {
        self.name = name
        self.properties = properties
        self.description = description
        self.apiDefinitionFileRef = apiDefinitionFileRef
    }
}

extension SchemaModelNode: StringView {
    public var view: String {
        return "Model \(self.name)\n\tdescription: \(self.description ?? "null")\n\t\(self.properties.view)"
    }
}
