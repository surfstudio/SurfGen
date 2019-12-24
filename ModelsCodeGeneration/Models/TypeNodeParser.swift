//
//  TypeNodeParser.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 06/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

indirect enum Type {
    case plain(String)
    case object(String)
    case array(Type)
    // case dictionary(key: Type, value: Type)
}

final class TypeNodeParser {

    func detectType(for typeNode: ASTNode) throws -> Type {
        guard case let .type(name) = typeNode.token else {
            throw GeneratorError.incorrectNodeToken("provided node is not type node")
        }

        switch typeNode.subNodes.count {
        case .zero:
            return .plain(name)
        case 1:
            guard let subNode = typeNode.subNodes.first else {
                throw GeneratorError.nodeConfiguration("can find subnode")
            }
            return try detectType(for: subNode)
        default:
            throw GeneratorError.incorrectNodeNumber("Type node contains to many nodes")
        }
    }

}
