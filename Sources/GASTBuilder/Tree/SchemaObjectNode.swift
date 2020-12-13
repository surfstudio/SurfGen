//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public struct SchemaObjectNode {
    public enum Possibility {
        case object(SchemaModelNode)
        case `enum`(SchemaEnumNode)
        case simple(String)
    }

    public var next: Possibility
}
