//
//  OperationNodeParser.swift
//  
//
//  Created by Dmitry Demyanov on 07.11.2020.
//

class OperationNodeParser {

    private enum ErrorMessages {

        static func errorMessage(for operationName: String = "") -> String {
            return "Could not parse operation \(operationName) node"
        }

    }

    private let mediaContentParser: MediaContentNodeParser
    private let parametersParser: ParametersNodeParser

    private let platform: Platform

    init(mediaContentParser: MediaContentNodeParser, parametersParser: ParametersNodeParser, platform: Platform) {
        self.mediaContentParser = mediaContentParser
        self.parametersParser = parametersParser
        self.platform = platform
    }

    func parse(operation: ASTNode, rootPath: String) throws -> OperationGenerationModel {
        // get http method
        guard
            let methodNode = operation.subNodes.typeNode,
            case let .type(method) = methodNode.token,
            let operationMethod = HttpMethod(rawValue: method)
        else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get method node from operation"),
                               message: ErrorMessages.errorMessage())
        }

        // get description
        var description: String?
        if let descriptionNode = operation.subNodes.descriptionNode,
           case let .description(text) = descriptionNode.token {
            description = text
        }

        // get parameters
        var parameters = [ParameterGenerationModel]()
        if let parametersNode = operation.subNodes.parametersNode {
            parameters = try wrap(parametersParser.parseParameters(node: parametersNode),
                                  with: ErrorMessages.errorMessage())
        }

        // get path
        guard
            let pathNode = operation.subNodes.pathNode,
            case let .path(path) = pathNode.token
        else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get path node from operation"),
                               message: ErrorMessages.errorMessage())
        }
        let pathModel = PathGenerationModel(name: path.pathName,
                                            path: path.pathWithParameterInterpolation(platform: platform),
                                            parameters: parameters.filter { $0.location == .path }.map { $0.name })

        // get name
        var name: String
        if let nameNode = operation.subNodes.nameNode, case let .name(identifier) = nameNode.token {
            name = identifier
        } else {
            name = path.operationName(with: operationMethod.name, rootPath: rootPath)
        }

        // get request body
        let requestBody = try wrap(mediaContentParser.parseRequestBody(node: operation.subNodes.requestBodyNode,
                                                                       forOperationName: name),
                                   with: ErrorMessages.errorMessage(for: name))

        // get response body
        let responseBody = try wrap(mediaContentParser.parseResponseBody(node: operation.subNodes.responseBodyNode,
                                                                         forOperationName: name),
                                    with: ErrorMessages.errorMessage(for: name))
        

        return OperationGenerationModel(name: name,
                                        description: description,
                                        path: pathModel,
                                        httpMethod: method,
                                        pathParameters: parameters.filter { $0.location == .path },
                                        queryParameters: parameters.filter { $0.location == .query },
                                        requestBody: requestBody,
                                        responseBody: responseBody)
    }
    
}
