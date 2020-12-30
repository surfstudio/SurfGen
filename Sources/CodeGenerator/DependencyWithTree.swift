//
//  File.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation
import GASTTree
import Common

/// Combines GASTRee and its dependencies
/// Because if this we can resolve global references form the `tree`
public struct DependencyWithTree {
    public let dependency: Dependency
    public let tree: RootNode

    public init(dependency: Dependency, tree: RootNode) {
        self.dependency = dependency
        self.tree = tree
    }
}
