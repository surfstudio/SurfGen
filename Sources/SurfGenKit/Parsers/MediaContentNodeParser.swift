//
//  MediaContentNodeParser.swift
//  
//
//  Created by Dmitry Demyanov on 08.11.2020.
//

class MediaContentNodeParser {

    private enum Constants {
        static let requestErrorMessage = "Could not parse request body"
        static let responseErrorMessage = "Could not parse response body"
        static let objectErrorMessage = "Could not parse object body"
    }

    func parseRequestBody(node: ASTNode?) throws -> RequestBodyGenerationModel.BodyType? {
        guard let requestBodyNode = node else {
            return nil
        }
        guard let mediaContentNode = requestBodyNode.subNodes.first else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get content node from request body"),
                               message: Constants.requestErrorMessage)
        }
        guard
            let encodingNode = mediaContentNode.subNodes.encodingNode,
            case let .encoding(encoding) = encodingNode.token
        else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get encoding from request body"),
                               message: Constants.requestErrorMessage)
        }

        switch RequestBodyGenerationModel.Encoding(rawValue: encoding) {
        case .json:
            return try wrap(parseBodyModel(node: mediaContentNode.subNodes.typeNode, withEncoding: .json),
                            with: Constants.requestErrorMessage)
        case .form:
            return try wrap(parseBodyModel(node: mediaContentNode.subNodes.typeNode, withEncoding: .form),
                            with: Constants.requestErrorMessage)
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
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get content node from response body"),
                               message: Constants.responseErrorMessage)
        }

        switch bodyType {
        case ASTConstants.object:
            return .unsupportedObject
        case ASTConstants.array:
            guard
                let arrayTypeNode = typeNode.subNodes.typeNode,
                case let .type(arrayModel) = arrayTypeNode.token
            else {
                throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get array schema from response body"),
                                   message: Constants.responseErrorMessage)
            }
            return .arrayOf(arrayModel)
        default:
            return .model(bodyType)
        }
    }

    private func parseBodyModel(node: ASTNode?, withEncoding encoding: RequestBodyGenerationModel.Encoding) throws -> RequestBodyGenerationModel.BodyType {
        guard
            let bodyNode = node,
            case let .type(bodyType) = bodyNode.token
        else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get encoded schema from request body"),
                               message: Constants.requestErrorMessage)
        }

        switch bodyType {
        case ASTConstants.object:
            return .dictionary(encoding, try wrap(parseObject(node: bodyNode),
                                                  with: "Could not parse request body"))
        case ASTConstants.array:
            guard
                let arrayTypeNode = bodyNode.subNodes.typeNode,
                case let .type(arrayModel) = arrayTypeNode.token
            else {
                throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get array schema from request body"),
                                   message: Constants.requestErrorMessage)
            }
            return .array(encoding, arrayModel)
        case ASTConstants.group:
            return .complex(try bodyNode.subNodes.map { try parseBodyModel(node: $0, withEncoding: encoding) })
        default:
            return .model(encoding, bodyType)
        }
    }

    private func parseObject(node objectNode: ASTNode) throws -> [String: String] {
        guard !objectNode.subNodes.isEmpty else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get object properties from request body"),
                               message: Constants.objectErrorMessage)
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
                throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't parse property object"),
                                   message: Constants.objectErrorMessage)
            }
            objectProperties[name] = type
        }

        return objectProperties
    }

}
