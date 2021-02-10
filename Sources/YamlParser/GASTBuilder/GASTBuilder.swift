//
//  GASTBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SurfGenKit
import Swagger

public final class GASTBuilder {

    static var defaultBuilder: GASTBuilder {
        let contentNodeBuilder = GASTContentNodeBuilder()
        let declarationNodeBuilder = GASTDeclNodeBuilder(contentNodeBuilder: contentNodeBuilder)
        return GASTBuilder(declarationNodeBuilder: declarationNodeBuilder)
    }
    
    private let declarationNodeBuilder: GASTDeclNodeBuilder

    init(declarationNodeBuilder: GASTDeclNodeBuilder) {
        self.declarationNodeBuilder = declarationNodeBuilder
    }

    func build(for models: [ComponentObject<Schema>]) throws -> ASTNode {
        let decls = try models.map {
            try wrap(declarationNodeBuilder.buildDeclNode(for: $0),
                     with: "Could not build declatration for model")
        }
        return Node(token: .root, decls)
    }
    
    func buildService(withRootPath rootPath: String, with operations: [Operation]) throws -> ASTNode {
        let decl = try wrap(declarationNodeBuilder.buildDeclNode(forRootPath: rootPath, with: operations),
                            with: "Could not build declaration for service")
        return Node(token: .root, [decl])
    }

}
