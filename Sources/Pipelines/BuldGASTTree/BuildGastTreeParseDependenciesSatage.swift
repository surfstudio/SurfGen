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
import ASTTree

public struct BuildGastTreeParseDependenciesSatage: PipelineStage {

    let builder: GASTBuilder
    let next: AnyPipelineStage<[DependencyWithTree]>

    public init(builder: GASTBuilder, next: AnyPipelineStage<[DependencyWithTree]>) {
        self.builder = builder
        self.next = next
    }

    public func run(with input: [OpenAPIASTTree]) throws {


        let arr = try input.map { astTree -> DependencyWithTree in
            let root = try wrap(self.builder.build(astTree: astTree),
                                message: "Error occured in stage `Build GAST for dependencies`")
            return DependencyWithTree(dependency: astTree.rawDependency, tree: root)
        }

        try self.next.run(with: arr)
    }
}
