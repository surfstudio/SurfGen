//
//  BuildGASTTreeEntryPoint.swift.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import ReferenceExtractor
import Common

// MARK: - Nested Types

extension BuildGASTTreeEntryPoint {
    public typealias ReferenceExtractorProvider = (URL) throws -> ReferenceExtractor
}

// MARK: - BuildGASTTreeEntryPoint Declaration

public struct BuildGASTTreeEntryPoint {

    private let refExtractorProvider: ReferenceExtractorProvider
    // TODO: - Do something with this type
    private let next: AnyPipelineStage<[Dependency]>// BuildGastTreeParseDependenciesSatage

    public init(refExtractorProvider: @escaping ReferenceExtractorProvider, next: AnyPipelineStage<[Dependency]>) {
        self.refExtractorProvider = refExtractorProvider
        self.next = next
    }

}

// MARK: - PipelineEntryPoint

extension BuildGASTTreeEntryPoint: PipelineStage {
    public func run(with input: URL) throws {
        // First stage - we need to extract all dependencies

        let extractor = try wrap(
            self.refExtractorProvider(input),
            message: "While configuring"
        )

        var (links, dependencies) = try wrap(
            extractor.extract(),
            message: "While extracting refs for \(input)"
        )
        links.append(input.absoluteString)

        // Second stage - Build GAST tree for each file

        try self.next.run(with: dependencies)
    }
}
