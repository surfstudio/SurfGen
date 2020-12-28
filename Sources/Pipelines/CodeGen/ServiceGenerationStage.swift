//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import Common
import CodeGenerator

public struct ServiceGenerationStage: PipelineEntryPoint {
    public var templatePathes: [String]

    public init(templatePathes: [String]) {
        self.templatePathes = templatePathes
    }

    public func run(with input: [[ServiceModel]]) throws {
        let compact = input.filter { $0.count != 0 }

        // do what you need

        let json = try wrap(JSONEncoder().encode(compact), message: "While serialize CodeGenerator models to JSON")

        try json.write(to: URL(string: "file:///Users/lastsprint/result.json")!)
    }
}
