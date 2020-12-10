//
//  GASTParameterNodeBuilder.swift
//  
//
//  Created by Dmitry Demyanov on 23.10.2020.
//

import Swagger
import SurfGenKit

final class GASTParameterNodeBuilder {
    
    func buildNode(for parameter: Parameter) throws -> ASTNode {
        let location = Node(token: .location(type: parameter.location.rawValue), [])
        let name = Node(token: .name(value: parameter.name), [])
        guard case let .schema(typeSchema) = parameter.type else {
            throw GASTBuilderError.undefinedTypeForField(parameter.name)
        }
        let type = try GASTTypeNodeBuilder().buildTypeNode(for: typeSchema.schema, referenceSafe: true)
        return Node(token: .parameter(isOptional: !parameter.required), [name, type, location])
    }

}

extension ParameterLocation {
    
    var needsRecording: Bool {
        switch self {
        case .path, .query:
            return true
        default:
            return false
        }
    }
}
