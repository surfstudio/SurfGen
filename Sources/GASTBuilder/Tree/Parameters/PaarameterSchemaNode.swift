//
//  ParameterSchemaNode.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct ParameterSchemaNode {

    public enum Possibility {
        case object(SchemaModelNode)
        case `enum`(SchemaEnumNode)
        case simple(PrimitiveType)
        case ref(String)
    }

    public var next: Possibility
}
