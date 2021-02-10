//
//  File.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation
import ReferenceExtractor
import Common

/// This implementation can extract dependencies from an array of files
///
/// If files contains duplicates, then they (duplicates) will be removed
public struct DirRefExtractor: PipelineStage {

    public typealias ReferenceExtractorProvider = (URL) throws -> ReferenceExtractor

    private let refExtractorProvider: ReferenceExtractorProvider
    private let next: AnyPipelineStage<[Dependency]>

    public init(refExtractorProvider: @escaping ReferenceExtractorProvider, next: AnyPipelineStage<[Dependency]>) {
        self.refExtractorProvider = refExtractorProvider
        self.next = next
    }

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
