//
//  main.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Pipelines
import ReferenceExtractor


let rootPath = URL(string: "/Users/lastsprint/repo/iOS/prod/tricolor-swagger/catalog/api.yaml")!
//let rootPath = URL(string: "/Users/lastsprint/repo/iOS/prod/tricolor-swagger/catalog/kek.yaml")!

let pipeline = BuldGASTTreeFactory.build()

do {
    try pipeline.run(with: .init(pathToSpec: rootPath))
} catch {
    print(error.localizedDescription)
}

