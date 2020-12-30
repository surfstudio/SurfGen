//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct ParameterTypeNode {
    public let schema: SchemaObjectNode

    public init(schema: SchemaObjectNode) {
        self.schema = schema
    }
}
