//
//  EntityGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

final class EntityGenerator: CodeGenerator {

    private let platform: Platform

    init(platform: Platform) {
        self.platform = platform
    }

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {

        let propertyGenerator = PropertyGenerator(platform: platform)
        let declModel = try wrap(ModelDeclNodeParser().getInfo(from: declNode),
                                 with: "Could not generate code for entity")

        let properties = try declModel.fields
            .map { try propertyGenerator.generateCode(for: $0, type: .entity) }
            .sorted { $0.entityName.propertyPriorityIndex > $1.entityName.propertyPriorityIndex }
        let className = ModelType.entity.form(name: declModel.name, for: platform)

        let code = try environment.renderTemplate(.nodeKitEntity(entityName: className,
                                                                 entryName: ModelType.entry.form(name: declModel.name, for: platform),
                                                                 properties: properties,
                                                                 description: declNode.description ?? ""))

        return .init(fileName: className.capitalizingFirstLetter().withFileExtension(platform.fileExtension),
                     code: code)
    }

}
