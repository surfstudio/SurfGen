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
    public func generateCode(for node: ASTNode, type: ModelType) throws -> [String] {
        guard  case .root = node.token else {
            throw GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as node with root token")
        }
        
        switch type {
        case .entry:
            var models = [String]()
            for decl in node.subNodes {
                models.append(try generateEntryCode(declNode: decl))
            }
            return models
        case .entity:
            return []
        }
    }

    private func generateEntryCode(declNode: ASTNode) throws -> String {
        guard let bundle = Bundle(identifier: Identifiers.bundle) else {
            throw ConfiguarionError.cantFindBundle("for entry generator method")
        }
        let environment = Environment(loader: FileSystemLoader(bundle: [bundle]))

        guard let contentNode = declNode.subNodes.last else {
            throw GeneratorError.nodeConfiguration("content node couldn't be resolved for decl node")
        }
        
        guard case let .name(value) = declNode.subNodes.first?.token else {
            throw GeneratorError.nodeConfiguration("name node couldn't be resolved for decl node")
        }

        let propertyGenerator = PropertyGenerator()
        var properties = [String]()
        for node in contentNode.subNodes {
            let propertyString = try propertyGenerator.generateCode(for: node, type: .entry)
            properties.append(propertyString)
        }
        
        return try environment.renderTemplate(name: "Codable.txt", context: [
            "className": ModelType.entry.formName(with: value),
            "properties": properties
        ])
    }

}
