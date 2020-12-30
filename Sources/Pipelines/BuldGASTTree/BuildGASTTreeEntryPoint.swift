//
//  BuildGASTTreeEntryPoint.swift.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import ReferenceExtractor

// MARK: - Nested Types

extension BuildGASTTreeEntryPoint {

    public typealias ReferenceExtractorProvider = (URL) throws -> ReferenceExtractor

    public struct Config {
        public let pathToSpec: URL

        public init(pathToSpec: URL) {
            self.pathToSpec = pathToSpec
        }
    }
}

// MARK: - BuildGASTTreeEntryPoint Declaration

public struct BuildGASTTreeEntryPoint {

    private let refExtractorProvider: ReferenceExtractorProvider
    private let next: BuildGastTreeParseDependenciesSatage

    public init(refExtractorProvider: @escaping ReferenceExtractorProvider, next: BuildGastTreeParseDependenciesSatage) {
        self.refExtractorProvider = refExtractorProvider
        self.next = next
    }

}

// MARK: - PipelineEntryPoint

extension BuildGASTTreeEntryPoint: PipelineEntryPoint {
    public func run(with input: Config) throws {
        // First stage - we need to extract all dependencies

        let extractor = try self.refExtractorProvider(input.pathToSpec)

        var (links, dependencies) = try extractor.extract()
        links.append(input.pathToSpec.absoluteString)

        // Second stage - Build GAST tree for each file

        try self.next.run(with: dependencies)
    }
}
