//
//  EntityGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

final class EntityGenerator: CodeGenerator {

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {

        let propertyGenerator = PropertyGenerator()
        let declModel = try ModelDeclNodeParser().getInfo(from: declNode)

        let properties = try declModel.fields
            .map { try propertyGenerator.generateCode(for: $0, type: .entity) }
            .sorted { $0.entityName.propertyPriorityIndex > $1.entityName.propertyPriorityIndex }
        let className = ModelType.entity.form(name: declModel.name)

        let code = try environment.renderTemplate(.nodeKitEntity(entityName: className,
                                                                 entryName: ModelType.entry.form(name: declModel.name),
                                                                 properties: properties,
                                                                 description: declNode.description ?? ""))

        return .init(fileName: className.capitalizingFirstLetter().withSwiftExt, code: code)
    }

}
