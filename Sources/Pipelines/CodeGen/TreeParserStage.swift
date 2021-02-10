//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import Common
import CodeGenerator

public struct TreeParserStage: PipelineStage {

    public let parser: TreeParser

    // just for prototyping. u think that in future we should chage this type from [[]]
    var next: AnyPipelineStage<[[PathModel]]>

    public init(next: AnyPipelineStage<[[PathModel]]>, parser: TreeParser) {
        self.next = next
        self.parser = parser
    }

    public func run(with input: [DependencyWithTree]) throws {
        let res = try wrap(self.parser.parse(trees: input), message: "While parsing GAST to generation models")
        try self.next.run(with: res)
    }
}
