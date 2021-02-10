//
//  BuildGastTreeParseDependenciesSatage.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import GASTBuilder
import Common
import GASTTree
import CodeGenerator

public struct BuildGastTreeParseDependenciesSatage: PipelineStage {

    let builder: GASTBuilder
    let next: AnyPipelineStage<[DependencyWithTree]>

    public init(builder: GASTBuilder, next: AnyPipelineStage<[DependencyWithTree]>) {
        self.builder = builder
        self.next = next
    }

    public func run(with input: [Dependency]) throws {

        var arr = [DependencyWithTree]()

        try input.forEach { dependency in
            let root = try wrap(self.builder.build(filePath: dependency.pathToCurrentFile),
                                message: "Error occured in stage `Build GAST for dependencies`")
            let dep = DependencyWithTree(dependency: dependency, tree: root)
            arr.append(dep)
        }

        try self.next.run(with: arr)
    }
}
