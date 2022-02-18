//
//  SourceCodeFolderDistributorStage.swift
//  
//
//  Created by volodina on 14.02.2022.
//

import Foundation
import CodeGenerator
import Common

/// Fixes destinationPath using apiDefinitionFileRef:
/// add nested folder name according specification in order to generate files in separate packages when the root is set.
///
/// For example:
/// sourceCode.destinationPath = "/users/project/api"
/// sourceCode.apiDefinitionFileRef = "/users/username/swagger/products/models.yaml"
/// specificationRootPath = "/users/username/swagger"
///
/// The fixed sourceCode.destinationPath will be "/users/project/api/products"
public struct SourceCodeFolderDistributorStage : PipelineStage {
    
    public typealias Input = [SourceCode]
    
    var next: AnyPipelineStage<[SourceCode]>
    
    private let specificationRootPath: String

    public init(next: AnyPipelineStage<[SourceCode]>, specificationRootPath: String) {
        self.next = next
        self.specificationRootPath = specificationRootPath
    }
    
    public func run(with input: [SourceCode]) throws {
        try next.run(with: input.map { try correctDestinationPath($0) })
    }
    
    private func correctDestinationPath(_ sourceCode: SourceCode) throws -> SourceCode {
        guard !specificationRootPath.isEmpty && sourceCode.apiDefinitionFileRef.hasSuffix(SourceCode.separatedFilesSuffix)
        else {
            return sourceCode
        }
        guard sourceCode.apiDefinitionFileRef.hasPrefix(specificationRootPath) else {
            throw CommonError(message: "Invalid \(sourceCode.apiDefinitionFileRef) for root \(specificationRootPath)")
        }
        let correctedDir = sourceCode.apiDefinitionFileRef
            .dropFirst(specificationRootPath.count)
            .dropLast(SourceCode.separatedFilesSuffix.count)
        return SourceCode(code: sourceCode.code,
                          fileName: sourceCode.fileName,
                          destinationPath: sourceCode.destinationPath + correctedDir,
                          apiDefinitionFileRef: sourceCode.apiDefinitionFileRef)
    }
}
