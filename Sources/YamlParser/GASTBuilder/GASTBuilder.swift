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

    func build(for models: [ComponentObject<Schema>]) throws -> ASTNode {
        let builder = GASTDeclNodeBuilder()
        let decls = try models.map { try builder.buildDeclNode(for: $0) }
        return Node(token: .root, decls)
    }

}
