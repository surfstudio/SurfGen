//
//  EntityGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

public protocol ModelGeneratable {
    func generateCode(declNode: ASTNode, environment: Environment) throws -> (String, String)
}

final class EntityGenerator: ModelGeneratable {

    func generateCode(declNode: ASTNode, environment: Environment) throws -> (String, String) {

        let propertyGenerator = PropertyGenerator()
        let (name, fields) = try DeclNodeParser().getInfo(from: declNode)

        let properties = try fields.map { try propertyGenerator.generateCode(for: $0, type: .entity) }
        let className = ModelType.entity.form(name: name)

        let code = try environment.renderTemplate(.nodeKitEntity(entityName: className,
                                                                 entryName: ModelType.entry.form(name: name),
                                                                 properties: properties))

        return (className.capitalizingFirstLetter().withSwiftExt, code)
    }

}
