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

    var isPlain: Bool {
        switch self {
        case .object:
            return false
        case .array(let subType):
            guard case .object = subType else { return true }
            return false
        default:
            return true
        }
    }

}

final class TypeNodeParser {

    private enum Constants {
        static let array = "array"
        static let object = "object"
    }

    /**
     Method for detection of concreate type for ASTNode with Type token
     */
    func detectType(for typeNode: ASTNode) throws -> Type {
        guard case let .type(name) = typeNode.token else {
            throw GeneratorError.incorrectNodeToken("provided node is not type node")
        }

        switch typeNode.subNodes.count {
        case .zero:
            return .plain(name)
        case 1:
            guard let subNode = typeNode.subNodes.first, case let .type(subName) = subNode.token else {
                throw GeneratorError.nodeConfiguration("can find subnode with correct type for typeNode with name \(name)")
            }
            
            if Constants.array == name {
                return .array(try detectType(for: subNode))
            }
            
            if Constants.object == name {
                return .object(subName)
            }
            throw GeneratorError.nodeConfiguration("provided node with name \(name) can not be resolved")
        default:
            throw GeneratorError.incorrectNodeNumber("Type node contains to many nodes")
        }

    }

}
