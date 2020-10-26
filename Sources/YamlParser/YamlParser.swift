//
//  YamlParser.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger
import PathKit
import SurfGenKit
import Foundation

public class YamlToGASTParser {

    // MARK: - Private Properties

    private let spec: SwaggerSpec

    // MARK: - Initialization

    public init(url: URL) throws {
        spec = try SwaggerSpec(url: url)
    }

    public init(path: PathKit.Path) throws {
        spec = try SwaggerSpec(path: path)
    }

    public init(string: String) throws {
        spec = try SwaggerSpec(string: string)
    }

    // MARK: - Public Methods

    /**
     Method parses swagger spec for provided 'modelName' excluding from generating objects model names from 'blackList' parameter
     */
    public func parseToGAST(for modelName: String, blackList: [String]) throws -> ASTNode {
        let allModels = spec.components.schemas
        let aliases = AliasFinder().findAlaises(for: allModels)

        /*
         After we have YAML-AST, we need to proccess it:
         1) We find all dependecies for provided modelName, so from array of all spec object we select model for proiveded name
            and all its dependecies (for more info check DependencyFinder description)
         2) Then as object can be complex: described as "group" (allOf/anyOf/oneOf) we need to unwrap it to convinient object with plain properties
            so we use GroupReplacer to change complex objects to plain
         3) We've already found alias-objects (for more info check AliasFinder description). And now we need to remove all alias objects from
            dependent models
         4) Filter all models from blackList
         5) And the last proccess step is to find properties in dependent models with alias types and change them to their real types
            (for example: we have property 'let id: ID' but ID is typealias for String, so we replace such typealiases using AliasReplacer, and
            as a result we would get 'let id: String')
         */
        let proccesedModels = allModels.apply { DependencyFinder().findDependencies(for: $0, modelName: modelName) } // # 1
                                       .apply { GroupReplacer().replace(for: $0) } // # 2
                                       .apply { $0.filter { aliases[$0.name] == nil } } // # 3
                                       .apply { $0.filter { !blackList.contains($0.name) } } // # 4
                                       .apply { AliasReplacer().replace(for: $0, aliases: aliases) } // # 5

        return try GASTBuilder().build(for: proccesedModels)
    }

    public func parseToGAST(forService serviceName: String) throws -> ASTNode {
        let allPaths = spec.paths
        let operations = allPaths.apply { PathFinder().findMatchingPaths(from: $0, for: serviceName) }
                                 .flatMap { $0.operations }
                                 .apply { DeprecatedFinder().removeDeprecated(from: $0) }
    
        return try GASTBuilder().build(service: serviceName, with: operations)
        
    }

}
