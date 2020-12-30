//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree
import Common

public struct TreeParserStage {

    var next: (([[ServiceModel]]) throws -> Void)?

    public init(next: (([[ServiceModel]]) throws -> Void)? = nil) {
        self.next = next
    }

    public func run(input: [DependencyWithTree]) throws {
        let parser = TreeParser()
        let res = try wrap(parser.parse(trees: input), message: "While parsing GAST to generation models")
        try self.next?(res)
    }
}

