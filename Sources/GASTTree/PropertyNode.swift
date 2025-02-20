//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public struct PropertyNode {

    public enum PossibleType {
        case array(ArrayTypeNode)
        case simple(Referenced<PrimitiveType>)
    }

    public let name: String
    public let type: PossibleType
    public let description: String?
    public let example: Any?
    public let nullable: Bool
    public let pattern: String?
    public let format: String?
    public let minimum: Int?
    public let maximum: Int?
    public let maxLength: Int?
    public let minLength: Int?

    public init(name: String,
                type: PossibleType,
                description: String?,
                example: Any?,
                nullable: Bool,
                pattern: String?,
                format: String?,
                minimum: Int?,
                maximum: Int?,
                maxLength: Int?,
                minLength: Int?) {
        self.name = name
        self.type = type
        self.description = description
        self.example = example
        self.nullable = nullable
        self.pattern = pattern
        self.format = format
        self.minimum = minimum
        self.maximum = maximum
        self.minLength = minLength
        self.maxLength = maxLength
    }
}

extension PropertyNode.PossibleType: StringView {
    public var view: String {
        switch self {
        case .array(let arr):
            return arr.view
        case .simple(let mod):
            return "\(mod)"
        }
    }
}

extension PropertyNode: StringView {
    public var view: String {
        return "Property \(self.name):\n\ttype:\(self.type.view)\n\tdescription:\(self.description ?? "null")\n\tnullable:\(self.nullable)\n\texample:\(self.example ?? "null")"
    }
}
