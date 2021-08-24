//
//  GenerationConfig.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Foundation
import CodeGenerator

public struct AnalytcsConfig: Decodable {
    public var logstashEnpointURI: String
    public var payload: [String: String]?
}

public struct GenerationConfig: Decodable {
    public var templates: [Template]
    public var analytcsConfig: AnalytcsConfig?
    public var prefixesToCutDownInServiceNames: [String]?
    public var useNewNullableDeterminationStrategy: Bool?
}
