//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct ParameterNode {

    public enum Location {
        case query
        case path
    }

    public let componentName: String?
    public let name: String
    public let location: Location
    public let description: String?
    public let type: ParameterTypeNode
    public let isRequired: Bool

    public init(componentName: String?,
                name: String,
                location: Location,
                description: String?,
                type: ParameterTypeNode,
                isRequired: Bool) {
        self.componentName = componentName
        self.name = name
        self.location = location
        self.description = description
        self.type = type
        self.isRequired = isRequired
    }
}

extension ParameterNode: StringView {
    public var view: String {
        return "name: \(self.name)\nlocation:\(location)\ndescription:\(description)\n"
    }
}
