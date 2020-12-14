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
    case `enum`(String)
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

enum PlainType: String {
    case boolean
    case integer
    case number
    case string
}

final class TypeNodeParser {

    private enum Constants {
        static let errorMessage = "Could not detect type"
    }

    private let platform: Platform

    init(platform: Platform) {
        self.platform = platform
    }

    /**
     Method for detection of concreate type for ASTNode with Type token
     */
    func detectType(for typeNode: ASTNode) throws -> Type {
        guard case let .type(name) = typeNode.token else {
            throw SurfGenError(nested: GeneratorError.incorrectNodeToken("provided node is not type node"),
                               message: Constants.errorMessage)
        }

        switch typeNode.subNodes.count {
        case .zero:
            guard let type = PlainType.init(rawValue: name) else {
                throw SurfGenError(nested: GeneratorError.nodeConfiguration("plain type name is not recognized"),
                                   message: Constants.errorMessage)
            }
            return .plain(platform.plainType(type: type))
        case 1:
            guard let subNode = typeNode.subNodes.first, case let .type(subName) = subNode.token else {
                throw SurfGenError(nested: GeneratorError.nodeConfiguration("can find subnode with correct type for typeNode with name \(name)"),
                                   message: Constants.errorMessage)
            }

            switch name {
            case ASTConstants.array:
                return .array(try detectType(for: subNode))
            case ASTConstants.object:
                return .object(subName)
            case ASTConstants.enum:
                guard let type = PlainType.init(rawValue: subName) else {
                    throw SurfGenError(nested: GeneratorError.nodeConfiguration("plain type name is not recognized"),
                                       message: Constants.errorMessage)
                }
                return .enum(platform.plainType(type: type))
            default:
                throw SurfGenError(nested: GeneratorError.nodeConfiguration("provided node with name \(name) can not be resolved"),
                                   message: Constants.errorMessage)

            }
        default:
            throw SurfGenError(nested: GeneratorError.incorrectNodeNumber("Type node contains to many nodes"),
                               message: Constants.errorMessage)
        }

    }

}
