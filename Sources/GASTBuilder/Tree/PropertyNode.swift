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
        case simple(Referenced<String>)
    }

    public let name: String
    public let type: PossibleType
    public let description: String?
    public let example: Any?
    public let nullable: Bool
}

extension PropertyNode.PossibleType: StringView {
    public var view: String {
        switch self {
        case .array(let arr):
            return arr.view
        case .simple(let mod):
            return mod.view
        }
    }
}

extension PropertyNode: StringView {
    public var view: String {
        return "Property \(self.name):\n\ttype:\(self.type.view)\n\tdescription:\(self.description ?? "null")\n\tnullable:\(self.nullable)\n\texample:\(self.example ?? "null")"
    }
}
