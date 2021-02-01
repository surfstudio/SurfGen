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
    

    public func run(with input: [SourceCode]) throws {
        
        for sourceCode in input {
            guard Path(sourceCode.destinationPath).exists else {
                throw CommonError(message: "directory \(sourceCode.destinationPath) doesn't exist")
            }
            
            let filePath = Path("\(sourceCode.destinationPath)/\(sourceCode.fileName)")
            try wrap(filePath.write(sourceCode.code),
                     message: "while writing file at \(filePath)")
        }
        
    }
}
