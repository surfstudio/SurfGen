//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

public struct ParameterModel {
    public let name: String
    public let location: ParameterNode.Location
    public let type: TypeModel
    public let description: String?
    public let isRequired: Bool
}
