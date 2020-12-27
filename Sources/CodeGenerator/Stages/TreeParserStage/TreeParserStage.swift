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


    public let parser: TreeParser

    var next: (([[ServiceModel]]) throws -> Void)?

    public init(next: (([[ServiceModel]]) throws -> Void)? = nil, parser: TreeParser) {
        self.next = next
        self.parser = parser
    }

    public func run(input: [DependencyWithTree]) throws {
        let res = try wrap(self.parser.parse(trees: input), message: "While parsing GAST to generation models")
        try self.next?(res)
    }
}

