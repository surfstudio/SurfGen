//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Common

public struct SchemaObjectNode {
    public enum Possibility {
        case object(SchemaModelNode)
        case `enum`(SchemaEnumNode)
        case simple(PrimitiveType)
    }

    public var next: Possibility
}

extension SchemaObjectNode: StringView {
    public var view: String {
        switch self.next {
        case .object(let obj):
            return "Schema:\n\ttype: Object\n\tNested:\n\t\t\(obj.view.tabShifted())"
        case .enum(let `enum`):
            return "Schema:\n\ttype: Enum\n\tNested:\n\t\t\(`enum`.view.tabShifted())"
        case .simple(let simple):
            return "Schema:\n\ttype: Simple\n\tNested:\n\t\t\(simple)"
        }
    }

}