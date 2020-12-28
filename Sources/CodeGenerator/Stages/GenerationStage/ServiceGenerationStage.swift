//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import Common

public struct ServiceGenerationStage {
    public var templatePathes: [String]


    public func run(input: [[ServiceModel]]) throws {
        let compact = input.filter { $0.count != 0 }

        let json = try wrap(JSONEncoder().encode(compact), message: "While serialize CodeGenerator models to JSON")

        try json.write(to: URL(string: "~/result.json")!)
    }
}
