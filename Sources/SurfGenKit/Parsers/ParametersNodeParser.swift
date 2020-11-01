//
//  ParametersNodeParser.swift
//  
//
//  Created by Dmitriy Demyanov on 31.10.2020.
//

class ParametersNodeParser {

    func parseParameters(node: ASTNode, location: ParameterLocation? = nil) throws -> [ParameterGenerationModel] {
        guard node.token == .parameters else {
            throw GeneratorError.incorrectNodeToken("Parameters header node has incorrect token")
        }
        
        let parameters = try node.subNodes.map { parameterNode -> ParameterGenerationModel in
            guard case let .parameter(isOptional) = parameterNode.token else {
                throw GeneratorError.incorrectNodeToken("Parameter node has incorrect token")
            }
            guard
                case let .type(locationString) = parameterNode.subNodes.typeNode?.token,
                let location = ParameterLocation(rawValue: locationString)
            else {
                throw GeneratorError.incorrectNodeToken("Parameter node has incorrect location type")
            }
            guard case let .name(name) = parameterNode.subNodes.nameNode?.token else {
                throw GeneratorError.incorrectNodeToken("Parameter node has incorrect name")
            }

            return ParameterGenerationModel(name: name, isOptional: isOptional, location: location)
        }
        
        guard let specifiedLocation = location else {
            return parameters
        }
        
        return parameters.filter { $0.location == specifiedLocation }
    }

}
