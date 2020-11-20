//
//  GASTParameterNodeBuilder.swift
//  
//
//  Created by Dmitry Demyanov on 23.10.2020.
//

import Swagger
import SurfGenKit

final class GASTParameterNodeBuilder {
    
    func buildNode(for parameter: Parameter) -> ASTNode {
        let type = Node(token: .type(name: parameter.location.rawValue), [])
        let name = Node(token: .name(value: parameter.name), [])
        return Node(token: .parameter(isOptional: !parameter.required), [name, type])
    }

}
