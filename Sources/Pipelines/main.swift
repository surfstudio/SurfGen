//
//  main.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Pipelines
import ReferenceExtractor
import SwiftCLI

//let rootPath = URL(string: "/Users/lastsprint/repo/iOS/prod/tricolor-swagger/catalog/api.yaml")!
////let rootPath = URL(string: "/Users/lastsprint/repo/iOS/prod/tricolor-swagger/catalog/kek.yaml")!
//
//let pipeline = BuildCodeGeneratorPipelineFactory.build()
//
//do {
//    try pipeline.run(with: rootPath)
//} catch {
//    print(error.localizedDescription)
//}

let version = "0.1.0"
let cli = CLI(name: "surfgen",
              version: version,
              description: "surfgen code generator",
              commands: [LintingCommend()])

_ = cli.goAndExit()
