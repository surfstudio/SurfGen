//
//  PipelineEntryPoint.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

/// This is the interface for entity which encapsulate all stages in pipeline
/// So it's the first stage of pipeline
public protocol PipelineStage {

    associatedtype Input

    /// Initiate the pipeline proccess
    /// - Parameter input: data which is nedded for pipeline
    func run(with input: Input) throws
}

extension PipelineStage {
    public func erase() -> AnyPipelineStage<Input> {
        return .init(nested: self)
    }
}

/// Just a Box for any specific type of PipelineEntryPoint
public struct AnyPipelineStage<Input>: PipelineStage {

    private let nested: _PipelineStageBox<Input>

    public init<Nested: PipelineStage>(nested: Nested) where Nested.Input == Input{
        self.nested = _PipelineStage(nested: nested)
    }

    public func run(with input: Input) throws {
        try self.nested.run(with: input)
    }
}

@usableFromInline
internal class _PipelineStageBox<Input>: PipelineStage {

    @usableFromInline
    func run(with input: Input) throws {
        fatalError("Abstract method was called")
    }
}

@usableFromInline
internal class _PipelineStage<Nested: PipelineStage>: _PipelineStageBox<Nested.Input> {
    let nested: Nested

    init(nested: Nested) {
        self.nested = nested
    }

    override func run(with input: Input) throws {
        try self.nested.run(with: input)
    }
}
