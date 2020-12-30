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
}

extension SchemaEnumNode: StringView {
    public var view: String {
        return "Type: \(self.type)\n\tCases:\(self.cases)"
    }
}
