//
//  ArrayTypeNode.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public struct ArrayTypeNode {
    public let itemsType: Referenced<String>

    public init(itemsType: Referenced<String>) {
        self.itemsType = itemsType
    }
}

extension ArrayTypeNode: StringView {
    public var view: String {
        return "Array:\n\t\(itemsType.view)"
    }
}
