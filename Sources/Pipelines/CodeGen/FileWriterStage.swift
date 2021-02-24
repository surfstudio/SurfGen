//
//  FileWriterStage.swift
//  
//
//  Created by Дмитрий on 13.01.2021.
//

import Foundation
import CodeGenerator
import Common
import PathKit

class FileWriterStage: PipelineStage {

    private let needRewriteExistingFiles: Bool

    private let logger: Logger?

    public init(needRewriteExistingFiles: Bool = false,
                logger: Logger? = nil) {
        self.needRewriteExistingFiles = needRewriteExistingFiles
        self.logger = logger
    }

    public func run(with input: [SourceCode]) throws {
        for sourceCode in input {
            
            let outputDirectory = Path(sourceCode.destinationPath)
            try outputDirectory.mkpath()

            let filePath = outputDirectory + sourceCode.fileName

            // Check if files already exist and need to be overwritten
            guard !filePath.exists || needRewriteExistingFiles else {
                logger?.info("File \(filePath.string) already exists and was not overwritten")
                continue
            }

            try wrap(filePath.write(sourceCode.code),
                     message: "While writing file at \(filePath)")
        }
        
    }
}
