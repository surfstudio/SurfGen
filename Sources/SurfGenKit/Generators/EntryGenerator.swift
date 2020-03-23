//
//  EntryGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

final class EntryGenerator: ModelGeneratable {

    func generateCode(declNode: ASTNode, environment: Environment) throws -> FileModel {

        let propertyGenerator = PropertyGenerator()
        let declModel = try DeclNodeParser().getInfo(from: declNode)
        
        let properties = try declModel.fields.map { try propertyGenerator.generateCode(for: $0, type: .entry) }
        let className = ModelType.entry.form(name: declModel.name)

        let code = try environment.renderTemplate(.nodeKitEntry(className: className, properties: properties))

        return .init(fileName: className.capitalizingFirstLetter().withSwiftExt, code: code)
    }

}
