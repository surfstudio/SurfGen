//
//  SourceCodeFolderDistributorStage.swift
//  
//
//  Created by volodina on 14.02.2022.
//

import Foundation
import CodeGenerator

public struct SourceCodeFolderDistributorStage : PipelineStage {
    
    public typealias Input = [SourceCode]
    
    var next: AnyPipelineStage<[SourceCode]>

    public init(next: AnyPipelineStage<[SourceCode]>) {
        self.next = next
    }
    
    public func run(with input: [SourceCode]) throws {
        for item in input {
            // todo add spec root to config; remove root from path; remove filename; add remains to dest path
        }
    }
}
