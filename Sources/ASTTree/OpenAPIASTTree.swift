//
//  OpenAPIASTTree.swift
//  
//
//  Created by Александр Кравченков on 22.10.2021.
//

import Foundation
import Common
import Swagger

/// Contains parsed OpenAPI specifications with path to their files
public struct OpenAPIASTTree {
    /// Dependencies of this tree by $ref value as a key
    public let dependencies: [String: SwaggerSpec]
    /// AST of the current OpenAPI file
    public let currentTree: SwaggerSpec
    public let rawDependency: Dependency

    public init(dependencies: [String: SwaggerSpec], currentTree: SwaggerSpec, rawDependency: Dependency) {
        self.dependencies = dependencies
        self.currentTree = currentTree
        self.rawDependency = rawDependency
    }
}
