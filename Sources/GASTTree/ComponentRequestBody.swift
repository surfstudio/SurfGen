//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation

public struct ComponentRequestBodyNode {

    public let name: String
    public let value: RequestBodyNode

    public init(name: String, value: RequestBodyNode) {
        self.name = name
        self.value = value
    }
}
