//
//  BuildGastTreeParseDependenciesSatage.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import GASTBuilder
import Common
import ReferenceExtractor
import GASTTree

public struct LinkWithDependencies {
    public let links: [String]
    public let dependencies: [Dependency]
}

public struct BuildGastTreeParseDependenciesSatage: PipelineEntryPoint {

    let builder: GASTBuilder
    let next: InitCodeGenerationStage

    public func run(with input: LinkWithDependencies) throws {
        var trees = [String: RootNode]()

        try input.links.forEach { path in
            let root = try wrap(self.builder.build(filePath: path),
                                message: "Error occured in stage `Build GAST for dependencies`")
            trees[path] = root
        }

        try self.next.run(with: trees)
    }
}
