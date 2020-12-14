//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct ParameterNode {

    public enum UsageType {
        case query
        case path
    }

    let name: String
    let usageType: UsageType
    let description: String
    let type: SchemaObjectNode
}
