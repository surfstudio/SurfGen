//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct PathNode {
    public var path: String
    public let parameters: [Referenced<ParameterNode>]
    public var operations: [OperationNode]

    public init(path: String, parameters: [Referenced<ParameterNode>], operations: [OperationNode]) {
        self.path = path
        self.parameters = parameters
        self.operations = operations
    }
}
