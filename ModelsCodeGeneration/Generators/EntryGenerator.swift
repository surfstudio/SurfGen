//
//  EntryGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 30/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

final class EntryGenerator: ModelGeneratable {

    func generateCode(declNode: ASTNode, environment: Environment) throws -> (String, String) {

        let propertyGenerator = PropertyGenerator()
        let (name, fields) = try DeclNodeParser().getInfo(from: declNode)
        
        let properties = try fields.map { try propertyGenerator.generateCode(for: $0, type: .entry) }
        let className = ModelType.entry.form(name: name)

        let code = try environment.renderTemplate(.nodeKitEntry(className: className, properties: properties))

        return (className.capitalizingFirstLetter().withSwiftExt, code)
    }

}
