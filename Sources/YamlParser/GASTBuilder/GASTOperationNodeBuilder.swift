//
//  GASTOperationNodeBuilder.swift
//  
//
//  Created by Dmitry Demyanov on 19.10.2020.
//

import Swagger
import SurfGenKit

final class GASTOperationNodeBuilder {

    func buildMethodNode(for operation: Swagger.Operation) throws -> ASTNode {
        var subNodes = [ASTNode]()

        // Http method
        subNodes.append(Node(token: .type(name: operation.method.rawValue), []))

        // Path
        subNodes.append(Node(token: .path(value: operation.path), []))

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
            let mediaContent = try GASTMediaContentNodeBuilder().buildMediaContentNode(with: requestBody.content)
            subNodes.append(Node(token: .requestBody(isOptional: !requestBody.required), [mediaContent]))
        }

        // Request parameters
        if !operation.parameters.isEmpty {
            subNodes.append(Node(token: .parameters, operation.parameters.map {
                GASTParameterNodeBuilder().buildNode(for: $0.value)
            }))
        }

        // Response type, schema or Void
        if let responseContent = operation.responses.filter({ $0.statusCode == 200 }).first?.response.value.content {
            let mediaContent = try GASTMediaContentNodeBuilder().buildMediaContentNode(with: responseContent)
            subNodes.append(Node(token: .responseBody, [mediaContent]))
        } else {
            subNodes.append(Node(token: .responseBody, []))
        }
        
        return Node(token: .operation, subNodes)
    }

}
