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

    private let platform: Platform
    private let warningCollector: WarningCollector

    init(platform: Platform, warningCollector: WarningCollector = WarningCollector.shared) {
        self.platform = platform
        self.warningCollector = warningCollector
    }

    func parseRequestBody(node: ASTNode?, forOperationName operationName: String) throws -> RequestBodyGenerationModel.BodyType? {
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
            warningCollector.add(warning: .unsupportedRequestEncoding(operationName, encoding))
            return .unsupportedEncoding(encoding)
        }
    }

    func parseResponseBody(node: ASTNode?, forOperationName operationName: String) throws -> ResponseBody {
        guard let responseBodyNode = node else {
            return .model(platform.voidType)
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
            warningCollector.add(warning: .complexObjectResponseBody(operationName))
            return .unsupportedObject
        case ASTConstants.array:
            guard
                let arrayTypeNode = typeNode.subNodes.typeNode,
                case let .type(arrayModel) = arrayTypeNode.token
            else {
                throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get array schema from response body"),
                                   message: Constants.responseErrorMessage)
            }
            let model = arrayModel.plainType(for: platform) ?? ModelType.entity.form(name: arrayModel,
                                                                                     for: platform)
            return .arrayOf(model.asArray(platform: platform))
        case ASTConstants.group:
            warningCollector.add(warning: .undefinedModelResponseBody(operationName))
            return .unsupportedObject
        default:
            return .model(bodyType.plainType(for: platform) ?? ModelType.entity.form(name: bodyType,
                                                                                     for: platform))
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
            let arrayType = arrayModel.plainType(for: platform) ?? ModelType.entity.form(name: arrayModel,
                                                                                         for: platform)
            return .array(encoding, arrayModel.lowercaseFirstLetter(), arrayType)
        case ASTConstants.group:
            return .complex(try bodyNode.subNodes.map { try parseBodyModel(node: $0, withEncoding: encoding) })
        default:
            let type = bodyType.plainType(for: platform) ?? ModelType.entity.form(name: bodyType, for: platform)
            return .model(encoding, bodyType.lowercaseFirstLetter(), type)
        }
    }

    private func parseObject(node objectNode: ASTNode) throws -> [String: String] {
        guard !objectNode.subNodes.isEmpty else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get object properties from body"),
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
            objectProperties[name] = type.plainType(for: platform) ?? type
        }

        return objectProperties
    }

}
