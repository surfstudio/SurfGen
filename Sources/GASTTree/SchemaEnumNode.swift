//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public struct SchemaEnumNode {
    public let name: String
    public let type: String
    public let cases: [String]
    public let description: String?

    public init(type: String, cases: [String], name: String, description: String?) {
        self.type = type
        self.cases = cases
        self.name = name
        self.description = description
    }
}

extension SchemaEnumNode: StringView {
    public var view: String {
        return "Type: \(self.type)\n\tCases:\(self.cases)"
    }
}
