//
//  EntryGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

final class EntryGenerator: CodeGenerator {

    private let platform: Platform

    init(platform: Platform) {
        self.platform = platform
    }

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {

        let propertyGenerator = PropertyGenerator(platform: platform)
        let declModel = try wrap(ModelDeclNodeParser().getInfo(from: declNode),
                                 with: "Could not generate entry code")
        
        let properties = try declModel.fields
            .map { try wrap(propertyGenerator.generateCode(for: $0, type: .entry),
                            with: "Could not generate model \(declModel.name)") }
            .sorted { $0.entryName.propertyPriorityIndex > $1.entryName.propertyPriorityIndex }

        let className = ModelType.entry.form(name: declModel.name, for: platform)

        let code = try environment.renderTemplate(.entry(className: className,
                                                                properties: properties,
                                                                description: declNode.description ?? ""),
                                                  from: ModelType.entry.templateName)

        return .init(fileName: className.capitalizingFirstLetter().withFileExtension(platform.fileExtension),
                     code: code)
    }

}
