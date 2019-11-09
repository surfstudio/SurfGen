//
//  RootGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public final class RootGenerator {

    /// for now this generator is supposed to generate code for complete AST
    public func generateCode(for node: ASTNode, type: ModelType) throws -> [String] {
        guard  case .root = node.token else {
            throw GeneratorError.incorrectNodeToken
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
        var codeLines: [String] = [
            KeyWords.nodekitImport + KeyWords.newLine,
            try DeclGenerator().generateCode(for: declNode, type: .entry)
        ]
        guard let contentNode = declNode.subNodes.last else {
            throw GeneratorError.nodeConfiguration
        }
        let propertyGenerator = PropertyGenerator()
        for node in contentNode.subNodes {
            let propertyString = try propertyGenerator.generateCode(for: node, type: .entry)
            codeLines.append(propertyString)
        }
        codeLines.append(KeyWords.codeEndBracket + KeyWords.newLine)
        codeLines.append(try RawMappableGenerator().generateCode(for: declNode, type: .entry))
        return codeLines.compactMap { $0 }.joined(separator: KeyWords.newLine)
    }

}
