//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public struct SchemaEnumNode {
    public let type: String
    public let cases: [String]

    public init(type: String, cases: [String]) {
        self.type = type
        self.cases = cases
    }
}

extension SchemaEnumNode: StringView {
    public var view: String {
        return "Type: \(self.type)\n\tCases:\(self.cases)"
    }
}
