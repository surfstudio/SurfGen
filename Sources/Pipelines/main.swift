//
//  main.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Pipelines
import ReferenceExtractor


let rootPath = URL(string: "/Users/lastsprint/repo/iOS/prod/tricolor-swagger/auth/api.yaml")!

let pipeline = BuldGASTTreeFactory.build()

try pipeline.run(with: .init(pathToSpec: rootPath))
