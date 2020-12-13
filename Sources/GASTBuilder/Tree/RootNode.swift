//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public struct RootNode {
    var components: [SchemaObjectNode]
}

extension RootNode: StringView {
    public var view: String {
        return "Root:\n\tComponents:\n\t\t\(components.view)"
    }
}
