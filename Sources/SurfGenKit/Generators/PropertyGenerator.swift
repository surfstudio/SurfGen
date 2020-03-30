//
//  PropertyGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 03/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public final class PropertyGenerator {

    /**
    Method for creating model for NodeKit's templates
    */
    public func generateCode(for node: ASTNode, type: ModelType) throws -> PropertyGenerationModel {
        guard case let .field(isOptional) = node.token else {
            throw GeneratorError.incorrectNodeToken("Property generator couldn't parse incorrect node")
        }

        guard
            let nameNode = node.subNodes.nameNode,
            let typeNode = node.subNodes.typeNode,
            case let .name(value) = nameNode.token,
            case .type = typeNode.token else {
                throw GeneratorError.nodeConfiguration("Property generator couldn't parse incorrect subnodes configurations")
        }

        let nodeType = try TypeNodeParser().detectType(for: typeNode)

        return .init(entryName: value,
                     entityName: value.snakeCaseToCamelCase(),
                     typeName: TypeNameBuilder().buildString(for: nodeType, isOptional: isOptional, modelType: type),
                     fromInit: FromDTOBuilder().buildString(for: nodeType, with: value, isOptional: isOptional),
                     toDTOInit: ToDTOBuilder().buildString(for: nodeType, with: value, isOptional: isOptional),
                     isPlain: nodeType.isPlain,
                     description: node.description?.replacingOccurrences(of: "\n", with: " "))
    }

}
