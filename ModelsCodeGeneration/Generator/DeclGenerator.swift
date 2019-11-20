//
//  DeclGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public final class DeclGenerator: CodeGeneratable {

    public func generateCode(for node: ASTNode, type: ModelType) throws -> String {
        // TODO: think if it really needed
//        guard  case .decl = node.token else {
//            throw GeneratorError.incorrectNodeToken
//        }
//
//        guard
//            let nameNode = node.subNodes.first,
//            case let .name(value) = nameNode.token else {
//                throw GeneratorError.nodeConfiguration
//        }
//        switch type {
//        case .entity:
//            return [
//                KeyWords.public,
//                KeyWords.struct,
//                type.formName(with: value),
//                KeyWords.codeStartBracket
//            ].joined(separator: " ")
//        case .entry:
//            return [
//                KeyWords.public,
//                KeyWords.struct,
//                "\(type.formName(with: value)):",
//                KeyWords.codable,
//                KeyWords.codeStartBracket
//            ].joined(separator: " ")
//        }
        return ""
    }

}
