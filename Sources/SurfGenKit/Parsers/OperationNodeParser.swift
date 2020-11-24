//
//  OperationNodeParser.swift
//  
//
//  Created by Dmitry Demyanov on 07.11.2020.
//

class OperationNodeParser {

    private enum Constants {
        static let errorMessage = "Could not parse operation node"
    }

    func parse(operation: ASTNode, forServiceName serviceName: String) throws -> OperationGenerationModel {
        // get http method
        guard
            let methodNode = operation.subNodes.typeNode,
            case let .type(method) = methodNode.token,
            let operationMethod = HttpMethod(rawValue: method)
        else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get method node from operation"),
                               message: Constants.errorMessage)
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
            parameters = try wrap(ParametersNodeParser().parseParameters(node: parametersNode),
                                  with: Constants.errorMessage)
        }

        // get path
        guard
            let pathNode = operation.subNodes.pathNode,
            case let .path(path) = pathNode.token
        else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get path node from operation"),
                               message: Constants.errorMessage)
        }

        // get name
        var name: String
        if let nameNode = operation.subNodes.nameNode, case let .name(identifier) = nameNode.token {
            name = identifier
        } else {
            name = path.operationName(forService: serviceName, with: operationMethod.name)
        }

        // get request body
        let requestBody = try wrap(MediaContentNodeParser().parseRequestBody(node: operation.subNodes.requestBodyNode),
                                   with: Constants.errorMessage)

        // get response body
        let responseBody = try wrap(MediaContentNodeParser().parseResponseBody(node: operation.subNodes.responseBodyNode),
                                    with: Constants.errorMessage)
        

        return OperationGenerationModel(name: name,
                                        description: description,
                                        path: path.pathName,
                                        httpMethod: method,
                                        pathParameters: parameters.filter { $0.location == .path },
                                        queryParameters: parameters.filter { $0.location == .query },
                                        requestBody: requestBody,
                                        responseBody: responseBody)
    }

    func parsePath(from operation: ASTNode) throws -> PathGenerationModel {
        guard
            let pathNode = operation.subNodes.pathNode,
            case let .path(path) = pathNode.token
        else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("Couldn't get path node from operation"),
                               message: Constants.errorMessage)
        }

        var parameters = [ParameterGenerationModel]()
        if let parametersNode = operation.subNodes.parametersNode {
            parameters = try wrap(ParametersNodeParser().parseParameters(node: parametersNode),
                                  with: Constants.errorMessage)
        }

        return PathGenerationModel(name: path.pathName,
                                   path: path.pathWithSwiftParameters(),
                                   parameters: parameters.filter { $0.location == .path }.map { $0.name })
    }
    
}
