//
//  PipelineEntryPoint.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

/// This is the interface for entity which encapsulate all stages in pipeline
/// So it's the first stage of pipeline
public protocol PipelineEntryPoint {

    associatedtype Input

    /// Initiate the pipeline proccess
    /// - Parameter input: data which is nedded for pipeline
    func run(with input: Input) throws
}

/// Just a Box for any specific type of PipelineEntryPoint
struct AnyPipelineEntryPoint<Input>: PipelineEntryPoint {

    private let nested: _PipelineEntryPointBox<Input>

    init<Nested: PipelineEntryPoint>(nested: Nested) where Nested.Input == Input{
        self.nested = _PipelineEntryPoint(nested: nested)
    }

    func run(with input: Input) throws {
        try self.nested.run(with: input)
    }
}

@usableFromInline
internal class _PipelineEntryPointBox<Input>: PipelineEntryPoint {

    @usableFromInline
    func run(with input: Input) throws {
        fatalError("Abstract method was called")
    }
}

@usableFromInline
internal class _PipelineEntryPoint<Nested: PipelineEntryPoint>: _PipelineEntryPointBox<Nested.Input> {
    let nested: Nested

    init(nested: Nested) {
        self.nested = nested
    }

    override func run(with input: Input) throws {
        try self.nested.run(with: input)
    }
}
