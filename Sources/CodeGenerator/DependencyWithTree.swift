//
//  DependencyWithTree.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation
import GASTTree
import Common

/// Combines GASTRee and its dependency
/// Because we can resolve global references form the `tree` with help of this
public struct DependencyWithTree {
    public let dependency: Dependency
    public let tree: RootNode

    public init(dependency: Dependency, tree: RootNode) {
        self.dependency = dependency
        self.tree = tree
    }
}
