//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct PathNode {
    public var path: String
    public var operations: [OperationNode]

    public init(path: String, operations: [OperationNode]) {
        self.path = path
        self.operations = operations
    }
}
