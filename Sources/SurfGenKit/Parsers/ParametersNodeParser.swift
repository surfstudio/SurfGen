//
//  ParametersNodeParser.swift
//  
//
//  Created by Dmitriy Demyanov on 31.10.2020.
//

class ParametersNodeParser {

    private enum Constants {
        static let errorMessage = "Could not parse parameters node"
    }

    private let platform: Platform

    init(platform: Platform) {
        self.platform = platform
    }

    func parseParameters(node: ASTNode) throws -> [ParameterGenerationModel] {
        guard node.token == .parameters else {
            throw SurfGenError(nested: GeneratorError.incorrectNodeToken("Parameters header node has incorrect token"),
                               message: Constants.errorMessage)
        }
        
        let parameters = try node.subNodes.map { parameterNode -> ParameterGenerationModel in
            guard case let .parameter(isOptional) = parameterNode.token else {
                throw SurfGenError(nested: GeneratorError.incorrectNodeToken("Parameter node has incorrect token"),
                                   message: Constants.errorMessage)
            }
            guard case var .type(name: type) = parameterNode.subNodes.typeNode?.token else {
                throw SurfGenError(nested: GeneratorError.incorrectNodeToken("Parameter node has incorrect type"),
                                   message: Constants.errorMessage)
            }
            
            if let plainType = type.plainType(for: platform) {
                type = plainType
            }

            if case let .type(name: objectType) = parameterNode.subNodes.typeNode?.subNodes.typeNode?.token {
                type = ModelType.entity.form(name: objectType, for: platform)
            }

            guard
                case let .location(locationString) = parameterNode.subNodes.locationNode?.token,
                let location = ParameterLocation(rawValue: locationString)
            else {
                throw SurfGenError(nested: GeneratorError.incorrectNodeToken("Parameter node has incorrect location type"),
                                   message: Constants.errorMessage)
            }
            guard case let .name(name) = parameterNode.subNodes.nameNode?.token else {
                throw SurfGenError(nested: GeneratorError.incorrectNodeToken("Parameter node has incorrect name"),
                                   message: Constants.errorMessage)
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
