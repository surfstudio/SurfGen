//
//  SwaggerCorrectorStage.swift
//  
//
//  Created by Dmitry Demyanov on 03.02.2021.
//

import Foundation
import CodeGenerator
import Common

class SwaggerCorrectorStage: PipelineStage {

    private let corrector: SwaggerCorrector

    var next: AnyPipelineStage<[[PathModel]]>

    init(next: AnyPipelineStage<[[PathModel]]>, corrector: SwaggerCorrector) {
        self.next = next
        self.corrector = corrector
    }

    public func run(with input: [[PathModel]]) throws {
        try next.run(with: input.map { correctService($0) })
    }

    private func correctService(_ service: [PathModel]) -> [PathModel] {
        return service.map { path in
            return PathModel(path: corrector.correctPath(path.path),
                             operations: path.operations)
        }
    }
}
