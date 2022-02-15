//
//  SourceCodeFolderDistributorStage.swift
//  
//
//  Created by volodina on 14.02.2022.
//

import Foundation
import CodeGenerator
import Common

/// Fixes destinationPath: add nested folder name according specification in order to generate files in separate packages
public struct SourceCodeFolderDistributorStage : PipelineStage {
    
    public typealias Input = [SourceCode]
    
    var next: AnyPipelineStage<[SourceCode]>
    
    private let specificationRootPath: String
    private let modelsSuffix = "models.yaml"

    public init(next: AnyPipelineStage<[SourceCode]>, specificationRootPath: String) {
        self.next = next
        self.specificationRootPath = specificationRootPath
    }
    
    public func run(with input: [SourceCode]) throws {
        try next.run(with: input.map { try correctDestinationPath($0) })
    }
    
    private func correctDestinationPath(_ sourceCode: SourceCode) throws -> SourceCode {
        if !specificationRootPath.isEmpty && sourceCode.apiDefinitionFileRef.hasSuffix(modelsSuffix) {
            guard sourceCode.apiDefinitionFileRef.hasPrefix(specificationRootPath) else {
                throw CommonError(message: "Invalid \(sourceCode.apiDefinitionFileRef) for root \(specificationRootPath)")
            }
            let correctedDir = sourceCode.apiDefinitionFileRef
                .dropFirst(specificationRootPath.count)
                .dropLast(modelsSuffix.count)
            return SourceCode(code: sourceCode.code,
                              fileName: sourceCode.fileName,
                              destinationPath: sourceCode.destinationPath + correctedDir,
                              apiDefinitionFileRef: sourceCode.apiDefinitionFileRef)
        }
        return sourceCode
    }
}
