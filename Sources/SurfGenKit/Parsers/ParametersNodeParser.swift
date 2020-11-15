//
//  ParametersNodeParser.swift
//  
//
//  Created by Dmitriy Demyanov on 31.10.2020.
//

class ParametersNodeParser {

    func parseParameters(node: ASTNode) throws -> [ParameterGenerationModel] {
        guard node.token == .parameters else {
            throw GeneratorError.incorrectNodeToken("Parameters header node has incorrect token")
        }
        
        let parameters = try node.subNodes.map { parameterNode -> ParameterGenerationModel in
            guard case let .parameter(isOptional) = parameterNode.token else {
                throw GeneratorError.incorrectNodeToken("Parameter node has incorrect token")
            }
            guard case let .type(name: type) = parameterNode.subNodes.typeNode?.token else {
                throw GeneratorError.incorrectNodeToken("Parameter node has incorrect type")
            }
            guard
                case let .location(locationString) = parameterNode.subNodes.locationNode?.token,
                let location = ParameterLocation(rawValue: locationString)
            else {
                throw GeneratorError.incorrectNodeToken("Parameter node has incorrect location type")
            }
            guard case let .name(name) = parameterNode.subNodes.nameNode?.token else {
                throw GeneratorError.incorrectNodeToken("Parameter node has incorrect name")
            }

            return ParameterGenerationModel(name: name.snakeCaseToCamelCase(),
                                            serverName: name,
                                            type: type,
                                            isOptional: isOptional,
                                            location: location)
        }
        
        return parameters
    }

}
