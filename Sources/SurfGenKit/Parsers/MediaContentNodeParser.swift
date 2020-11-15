//
//  MediaContentNodeParser.swift
//  
//
//  Created by Dmitry Demyanov on 08.11.2020.
//

class MediaContentNodeParser {

    func parseRequestBody(node: ASTNode?) throws -> RequestBody? {
        guard let requestBodyNode = node else {
            return nil
        }
        guard let mediaContentNode = requestBodyNode.subNodes.first else {
            throw GeneratorError.nodeConfiguration("Couldn't get content node from request body")
        }
        guard
            let encodingNode = mediaContentNode.subNodes.encodingNode,
            case let .encoding(encoding) = encodingNode.token
        else {
            throw GeneratorError.nodeConfiguration("Couldn't get encoding from request body")
        }

        switch RequestBody.Encoding(rawValue: encoding) {
        case .json:
            return try parseBodyModel(node: mediaContentNode, withEncoding: .json)
        case .form:
            return try parseBodyModel(node: mediaContentNode, withEncoding: .form)
        case .multipartForm:
            return .multipartModel
        case .none:
            return .unsupportedEncoding(encoding)
        }
    }

    func parseResponseBody(node: ASTNode?) throws -> ResponseBody? {
        guard let responseBodyNode = node else {
            return nil
        }
        guard
            let mediaContentNode = responseBodyNode.subNodes.first,
            let typeNode = mediaContentNode.subNodes.typeNode,
            case let .type(bodyType) = typeNode.token
        else {
            throw GeneratorError.nodeConfiguration("Couldn't get content node from response body")
        }

        switch bodyType {
        case ASTConstants.object:
            return .unsupportedObject
        case ASTConstants.array:
            guard
                let arrayTypeNode = typeNode.subNodes.typeNode,
                case let .type(arrayModel) = arrayTypeNode.token
            else {
                throw GeneratorError.nodeConfiguration("Couldn't get array schema from response body")
            }
            return .arrayOf(arrayModel)
        default:
            return .model(bodyType)
        }
    }

    private func parseBodyModel(node: ASTNode, withEncoding encoding: RequestBody.Encoding) throws -> RequestBody {
        guard
            let typeNode = node.subNodes.typeNode,
            case let .type(bodyType) = typeNode.token
        else {
            throw GeneratorError.nodeConfiguration("Couldn't get encoded schema from request body")
        }

        switch bodyType {
        case ASTConstants.object:
            return .dictionary(encoding, try parseObject(node: typeNode))
        case ASTConstants.array:
            guard
                let arrayTypeNode = typeNode.subNodes.typeNode,
                case let .type(arrayModel) = arrayTypeNode.token
            else {
                throw GeneratorError.nodeConfiguration("Couldn't get array schema from request body")
            }
            return .array(encoding, arrayModel)
        default:
            return .model(encoding, bodyType)
        }
    }

    private func parseObject(node objectNode: ASTNode) throws -> [String: String] {
        guard !objectNode.subNodes.isEmpty else {
            throw GeneratorError.nodeConfiguration("Couldn't get object properties from request body")
        }

        var objectProperties = [String: String]()
        for propertyNode in objectNode.subNodes {
            guard
                propertyNode.token == .field(isOptional: Bool()),
                let nameNode = propertyNode.subNodes.nameNode,
                case let .name(name) = nameNode.token,
                let typeNode = propertyNode.subNodes.typeNode,
                case let .type(type) = typeNode.token
            else {
                throw GeneratorError.nodeConfiguration("Couldn't parse property object")
            }
            objectProperties[name] = type
        }

        return objectProperties
    }

}
