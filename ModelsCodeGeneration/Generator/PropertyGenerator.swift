//
//  PropertyGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 03/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public final class PropertyGenerator: CodeGeneratable {

    public func generateCode(for node: ASTNode, type: ModelType) throws -> String {
        guard case let .field(isOptional) = node.token else {
            throw GeneratorError.incorrectNodeToken
        }
        guard
            let nameNode = node.subNodes.first,
            let typeNode = node.subNodes.last,
            case let .name(value) = nameNode.token,
            case let .type(name) = typeNode.token else {
                throw GeneratorError.nodeConfiguration
        }
        let typeName = StandardTypes.all.contains(name) ? name : "\(name)\(type.name)"
        let codeLine = [
            KeyWords.public,
            KeyWords.let,
            "\(value):",
            "\(typeName)\(isOptional.keyWord)"
        ].joined(separator: " ")
        
        return KeyWords.formattingSpace + codeLine
    }
    
}

extension Bool {
    
    var keyWord: String {
        return self ? "?" : ""
    }

}
