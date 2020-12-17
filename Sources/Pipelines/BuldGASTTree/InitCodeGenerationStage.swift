//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import CodeGenerator
import GASTTree

struct InitCodeGenerationStage: PipelineEntryPoint {
    func run(with input: [String : RootNode]) throws {
        try TreeParserStage().run(input: input)
    }
}
