//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation

public struct ComponentResponseNode {

    public let name: String
    public let value: ResponseNode

    public init(name: String, value: ResponseNode) {
        self.name = name
        self.value = value
    }
}
