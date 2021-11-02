//
//  AnyPipelineStageStub.swift
//  
//
//  Created by Александр Кравченков on 26.10.2021.
//

import Foundation
import Common
import Pipelines

class AnyPipelineStageStub<T>: PipelineStage {
    typealias Input = T

    public var input: T?

    func run(with input: T) throws {
        self.input = input
    }
}
