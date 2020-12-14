//
//  OperationNode.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct OperationNode {
    public let method: String
    public let description: String?
    public let summary: String?
    public let parameters: [Referenced<ParameterNode>]
}
