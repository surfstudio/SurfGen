//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation

public struct MediaTypeObjectNode {
    /// For example `application/json`
    public let typeName: String
    public let schema: SchemaObjectNode

    public init(typeName: String, schema: SchemaObjectNode) {
        self.typeName = typeName
        self.schema = schema
    }
}
