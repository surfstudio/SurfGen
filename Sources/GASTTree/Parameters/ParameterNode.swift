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

    public let name: String
    public let location: Location
    public let description: String?
    public let type: ParameterTypeNode
    public let isRequired: Bool

    public init(name: String,
                location: Location,
                description: String?,
                type: ParameterTypeNode,
                isRequired: Bool) {
        self.name = name
        self.location = location
        self.description = description
        self.type = type
        self.isRequired = isRequired
    }
}
