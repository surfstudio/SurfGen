//
//  RootGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

public final class RootGenerator {

    /// for now this generator is supposed to generate code for complete AST
    public func generateCode(for node: ASTNode, type: ModelType) throws -> [(String, String)] {
        guard  case .root = node.token else {
            throw GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as node with root token")
        }
        
        switch type {
        case .entry:
            var models = [(String, String)]()
            for decl in node.subNodes {
                models.append(try generateEntryCode(declNode: decl))
            }
            return models
        case .entity:
            var models = [(String, String)]()
            for decl in node.subNodes {
                models.append(try generateEntityCode(declNode: decl))
            }
            return models
        }
    }

    private func generateEntryCode(declNode: ASTNode) throws -> (String, String) {
        let environment = formEnvironment()
    
        guard let contentNode = declNode.subNodes.last else {
            throw GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node")
        }

        guard case let .name(value) = declNode.subNodes.first?.token else {
            throw GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node")
        }

        let propertyGenerator = PropertyGenerator()
        var properties = [PropertyGenerationModel]()
        for node in contentNode.subNodes {
            let propertyString = try propertyGenerator.generateCode(for: node, type: .entry)
            properties.append(propertyString)
        }

        let code = try environment.renderTemplate(name: "EntryCodable.txt", context: [
            "className": ModelType.entry.formName(with: value),
            "properties": properties
        ])

        return (ModelType.entry.formName(with: value).capitalizingFirstLetter().withSwiftExt, code)
    }

    private func generateEntityCode(declNode: ASTNode) throws -> (String, String) {
        let environment = formEnvironment()

        guard let contentNode = declNode.subNodes.last else {
            throw GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node")
        }
        
        guard case let .name(value) = declNode.subNodes.first?.token else {
            throw GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node")
        }

        let propertyGenerator = PropertyGenerator()
        var properties = [PropertyGenerationModel]()
        for node in contentNode.subNodes {
            let propertyString = try propertyGenerator.generateCode(for: node, type: .entity)
            properties.append(propertyString)
        }
                
        let code = try environment.renderTemplate(name: "EntityDTOConvertable.txt", context: [
            "entityName": ModelType.entity.formName(with: value),
            "entryName": ModelType.entry.formName(with: value),
            "codeOpenBracket": KeyWords.codeStartBracket,
            "properties": properties
        ])
        
        return (ModelType.entity.formName(with: value).capitalizingFirstLetter().withSwiftExt, code)
    }

    private func formEnvironment() -> Environment {
        let ext = Extension()
        ext.registerFilter("toCamelCase") { (value) -> Any? in
            guard let str = value as? String else {
                return value
            }
            return str.snakeCaseToCamelCase()
        }
        return Environment(loader: FileSystemLoader(bundle: [Bundle(for: type(of: self))]), extensions: [ext])
    }

}
