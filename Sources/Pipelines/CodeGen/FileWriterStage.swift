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
    

    public func run(with input: [GeneratedCode]) throws {
        
        for sourceCode in input {
            let filePath = "\(sourceCode.destinationPath)/\(sourceCode.fileName)"
            try wrap(Path(filePath).write(sourceCode.code),
                     message: "while writing file at \(filePath)")
        }
        
    }
}
