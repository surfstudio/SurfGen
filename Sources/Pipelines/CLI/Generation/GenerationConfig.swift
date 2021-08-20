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
    public var prefixesToCutDownInServiceNames: [String]?
}

public struct GenerationConfig: Decodable {

    var templates: [Template]
    var analytcsConfig: AnalytcsConfig?
}
