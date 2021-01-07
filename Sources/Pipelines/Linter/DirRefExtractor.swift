//
//  File.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation
import ReferenceExtractor
import Common

// MARK: - Nested Types

extension DirRefExtractor {
    public typealias ReferenceExtractorProvider = (URL) throws -> ReferenceExtractor
}

// MARK: - BuildGASTTreeEntryPoint Declaration

public struct DirRefExtractor {

    private let refExtractorProvider: ReferenceExtractorProvider
    private let next: AnyPipelineEntryPoint<[Dependency]>

    public init(refExtractorProvider: @escaping ReferenceExtractorProvider, next: AnyPipelineEntryPoint<[Dependency]>) {
        self.refExtractorProvider = refExtractorProvider
        self.next = next
    }

}

// MARK: - PipelineEntryPoint

extension DirRefExtractor: PipelineEntryPoint {
    public func run(with input: [URL]) throws {

        let result = try Set(input.map(getDependecies(from:)).reduce(into: [Dependency](), { $0.append(contentsOf: $1) }))

        // Second stage - Build GAST tree for each file

        try self.next.run(with: [Dependency](result))
    }

    func getDependecies(from file: URL) throws -> [Dependency] {
        let extractor = try wrap(
            self.refExtractorProvider(file),
            message: "While configuring"
        )

        let (_, dependencies) = try wrap(
            extractor.extract(),
            message: "While extracting refs for \(file.absoluteString)"
        )

        return dependencies
    }
}
