//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import CodeGenerator
import GASTTree
import Common

public struct InitCodeGenerationStage: PipelineStage {

    public var next: TreeParserStage

    public init(parserStage: TreeParserStage) {
        self.next = parserStage
    }

    public func run(with input: [DependencyWithTree]) throws {
        try wrap(self.next.run(with: input), message: "In `Init Code Generation Stage`")
    }
}
