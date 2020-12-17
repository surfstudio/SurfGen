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

    public init() {
        
    }

    public func run(input: [String: RootNode]) throws {
        let parser = TreeParser()

        let res = try wrap(parser.parse(tree: input), message: "While parsing GAST to generation models")

        print(res)
    }
}

