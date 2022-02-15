//
//  SourceCodeFolderDistributorStage.swift
//  
//
//  Created by volodina on 14.02.2022.
//

import Foundation
import CodeGenerator

/// Fixes destinationPath: add nested folder name according specification in order to generate files in separate packages
public struct SourceCodeFolderDistributorStage : PipelineStage {
    
    public typealias Input = [SourceCode]
    
    var next: AnyPipelineStage<[SourceCode]>
    
    private let specificationRootPath: String

    public init(next: AnyPipelineStage<[SourceCode]>, specificationRootPath: String) {
        self.next = next
        self.specificationRootPath = specificationRootPath
    }
    
    public func run(with input: [SourceCode]) throws {
        try next.run(with: input.map { correctDestinationPath($0) })
    }
    
    private func correctDestinationPath(_ sourceCode: SourceCode) -> SourceCode {
        // todo add spec root to config; remove root from path; remove filename; add remains to dest path
        return sourceCode
    }
}
