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
        let (name, fields) = try DeclNodeParser.getInfo(from: declNode)
        
        var properties = [PropertyGenerationModel]()
        for node in fields {
            let propertyString = try propertyGenerator.generateCode(for: node, type: .entry)
            properties.append(propertyString)
        }

        let className = ModelType.entry.formName(with: name)

        let code = try environment.renderTemplate(name: "EntryCodable.txt", context: [
            "className": className,
            "properties": properties
        ])

        return (className.capitalizingFirstLetter().withSwiftExt, code)
    }

}

