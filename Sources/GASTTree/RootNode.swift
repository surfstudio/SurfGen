//
//  RootNode.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public struct RootNode {
    public var schemas: [SchemaObjectNode]
    public var parameters: [ParameterNode]
    public var services: [PathNode]

    public init(schemas: [SchemaObjectNode], parameters: [ParameterNode], services: [PathNode]) {
        self.schemas = schemas
        self.parameters = parameters
        self.services = services
    }
}

extension RootNode: StringView {
    public var view: String {
        return "Root:\n\tSchemas:\n\t\t\(schemas.view)\n\nParameters:\(parameters)"
    }
}
