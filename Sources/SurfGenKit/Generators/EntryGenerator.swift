//
//  EntryGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

final class EntryGenerator: CodeGenerator {

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {

        let propertyGenerator = PropertyGenerator()
        let declModel = try wrap(ModelDeclNodeParser().getInfo(from: declNode),
                                 with: "Could not generate entry code")
        
        let properties = try declModel.fields
            .map { try propertyGenerator.generateCode(for: $0, type: .entry) }
            .sorted { $0.entryName.propertyPriorityIndex > $1.entryName.propertyPriorityIndex }

        let className = ModelType.entry.form(name: declModel.name)

        let code = try environment.renderTemplate(.nodeKitEntry(className: className, properties: properties))

        return .init(fileName: className.capitalizingFirstLetter().withSwiftExt, code: code)
    }

}
