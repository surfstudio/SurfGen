//
//  GASTOperationNodeBuilder.swift
//  
//
//  Created by Dmitry Demyanov on 19.10.2020.
//

import Swagger
import SurfGenKit

final class GASTOperationNodeBuilder {

    private let specValidator = SpecValidator()

    func buildMethodNode(for operation: Swagger.Operation) throws -> ASTNode {
        var subNodes = [ASTNode]()

        // Http method
        let method = operation.method.rawValue
        subNodes.append(Node(token: .type(name: method), []))

        // Path
        guard specValidator.isPathValid(operation.path) else {
            throw SurfGenError(nested: GASTBuilderError.invalidPath(operation.path),
                               message: "Path should not contain query parameters")
        }
        let path = operation.path
        subNodes.append(Node(token: .path(value: path), []))

        // Name, if provided
        if let identifier = operation.identifier {
            subNodes.append(Node(token: .name(value: identifier), []))
        }

        // Description, if provided
        if let description = operation.summary ?? operation.description {
            subNodes.append(Node(token: .description(description), []))
        }

        // Request body, if exists
        if let requestBody = operation.requestBody?.value {
            let mediaContent = try wrap(GASTMediaContentNodeBuilder().buildMediaContentNode(with: requestBody.content),
                                        with: "Could not parse request body for operation \(method)\(path)")
            subNodes.append(Node(token: .requestBody(isOptional: !requestBody.required), [mediaContent]))
        }

        // Request parameters
        if let externalParameter = specValidator.findInvalidParameter(in: operation.parameters) {
            throw SurfGenError(nested: GASTBuilderError.invalidParameter(externalParameter),
                               message: "Could not parse parameters for operation \(method)\(path)")
        }
        let suitableParameters = operation.parameters.filter { $0.value.location.needsRecording }
        if !suitableParameters.isEmpty {
            subNodes.append(Node(token: .parameters, try suitableParameters.map {
                try GASTParameterNodeBuilder().buildNode(for: $0.value)
            }))
        }

        // Response type, schema or Void
        if let responseContent = operation.responses.filter({ $0.statusCode == 200 }).first?.response.value.content {
            let mediaContent = try wrap(GASTMediaContentNodeBuilder().buildMediaContentNode(with: responseContent),
                                        with: "Could not parse response body for operation \(method)\(path)")
            subNodes.append(Node(token: .responseBody, [mediaContent]))
        }
        
        return Node(token: .operation, subNodes)
    }

}
