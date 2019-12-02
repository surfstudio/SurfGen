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
        let (name, fields) = try NodesValidator.getInfo(from: declNode)
        
        var properties = [PropertyGenerationModel]()
        for node in fields {
            let propertyString = try propertyGenerator.generateCode(for: node, type: .entity)
            properties.append(propertyString)
        }
        
        let className = ModelType.entity.formName(with: name)

        let code = try environment.renderTemplate(name: "EntityDTOConvertable.txt", context: [
            "entityName": className,
            "entryName": ModelType.entry.formName(with: name),
            "codeOpenBracket": KeyWords.codeStartBracket,
            "properties": properties
        ])
        
        return (className.capitalizingFirstLetter().withSwiftExt, code)
    }

}
