//
//  AnyPipelineStageStub.swift
//  
//
//  Created by Александр Кравченков on 22.10.2021.
//

import Foundation
import Common
import Pipelines

/// Use for stubbing pipeline
/// Saves result of parent stage to variable and finishes work
public class AnyPipelineStageStub<T>: PipelineStage {

    public typealias Input = T
    
    /// Result of parent stage
    public var result: T?

    public func run(with input: T) throws {
        self.result = input
    }
}
