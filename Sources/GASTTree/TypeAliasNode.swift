//
//  File.swift
//  
//
//  Created by Александр Кравченков on 26.12.2020.
//

import Foundation

public struct PrimitiveTypeAliasNode {

    public let name: String
    public let type: PrimitiveType

    public init(name: String, type: PrimitiveType) {
        self.name = name
        self.type = type
    }
}
