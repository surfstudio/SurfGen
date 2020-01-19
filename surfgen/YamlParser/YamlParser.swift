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

    public func parseToGAST(for modelName: String) throws -> ASTNode {
        let allModels = spec.components.schemas
        let aliases = AliasFinder().findAlaises(for: allModels)

        let proccesedModels = allModels.apply { DependencyFinder().findDependencies(for: $0, modelName: modelName) } // find all dependent models
                                       .apply { GroupReplacer().replace(for: $0) } // replace all group nodes
                                       .apply { $0.filter { aliases[$0.name] == nil } } // filter alias objct nodes
                                       .apply { AliasReplacer().replace(for: $0, aliases: aliases) } // replace aliases from all properties

        return try GASTBuiler().build(for: proccesedModels)
    }

}
