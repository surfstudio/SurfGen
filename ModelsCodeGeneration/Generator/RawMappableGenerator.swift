//
//  RawMappableGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public final class RawMappableGenerator: CodeGeneratable {

    private enum Constants {
        static let typealiasString = "public typealias Raw = Json"
        static let rawMappableProtocol = "RawMappable"
    }

    public func generateCode(for node: ASTNode, type: ModelType) throws -> String {
        guard  case .decl = node.token else {
            throw GeneratorError.incorrectNodeToken
        }
           
        guard
            let nameNode = node.subNodes.first,
            case let .name(value) = nameNode.token else {
                throw GeneratorError.nodeConfiguration
        }
        return [
            KeyWords.rawMappableMark + KeyWords.newLine,
            [KeyWords.extension, "\(type.formName(with: value)):", Constants.rawMappableProtocol, KeyWords.codeStartBracket].joined(separator: " "),
            [KeyWords.formattingSpace, Constants.typealiasString].joined(),
            KeyWords.codeEndBracket
        ].joined(separator: KeyWords.newLine)
    }

}


