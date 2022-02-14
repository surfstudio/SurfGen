//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Common

/// Iat this moment array contains only 1 fild which is value and type at the same time
/// But later it may be extended with new fields
public struct SchemaArrayNode {
    public let name: String
    public let type: SchemaObjectNode
    public let apiDefinitionFileRef: String

    public init(name: String, type: SchemaObjectNode, apiDefinitionFileRef: String) {
        self.name = name
        self.type = type
        self.apiDefinitionFileRef = apiDefinitionFileRef
    }
}

public struct SchemaObjectNode {
    public indirect enum Possibility {
        case object(SchemaModelNode)
        case `enum`(SchemaEnumNode)
        case simple(PrimitiveTypeAliasNode)
        case reference(String)
        case array(SchemaArrayNode)
        case group(SchemaGroupNode)
    }

    public var next: Possibility

    public init(next: Possibility) {
        self.next = next
    }
}
