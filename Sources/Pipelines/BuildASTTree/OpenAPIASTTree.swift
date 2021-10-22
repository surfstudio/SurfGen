//
//  OpenAPIASTTree.swift
//  
//
//  Created by Александр Кравченков on 21.10.2021.
//

import Foundation
import Swagger
import Common

/// Contains parsed OpenAPI specifications with path to their files
public struct OpenAPIASTTree {
    /// Dependencies of this tree by $ref value as a key
    public let dependencies: [String: SwaggerSpec]
    /// AST of the current OpenAPI file
    public let currentTree: SwaggerSpec
    public let rawDependency: Dependency
}
