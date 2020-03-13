//
//  GASTDeclNodeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import Swagger
import SurfGenKit

final class GASTDeclNodeBuilder {

    func buildDeclNode(for model: ComponentObject<Schema>) throws -> ASTNode {
        let nameNode = Node(token: .name(value: model.name), [])
        guard let object = model.value.type.object else {
            throw GASTBuilderError.nonObjectNodeFound(model.name)
        }
        let contentNode = try GASTContentNodeBuilder().buildContentSubnodes(for: object)
        return Node(token: .decl, [nameNode, contentNode])
    }

}
