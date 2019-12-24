//
//  PropertyGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 03/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public struct PropertyGenerationModel: Equatable {

    let entryName: String
    let type: String
    let entityName: String
    let fromInit: String
    let toDTOInit: String

    init(entryName: String, entityName: String, typeName: String, fromInit: String, toDTOInit: String) {
        self.entryName = entryName
        self.entityName = entityName
        self.type = typeName
        self.fromInit = fromInit
        self.toDTOInit = toDTOInit
    }

}

public final class PropertyGenerator {

    public func generateCode(for node: ASTNode, type: ModelType) throws -> PropertyGenerationModel {
        guard case let .field(isOptional) = node.token else {
            throw GeneratorError.incorrectNodeToken("Property generator couldn't parse incorrect node")
        }

        guard
            let nameNode = node.subNodes.first,
            let typeNode = node.subNodes.last,
            case let .name(value) = nameNode.token,
            case .type = typeNode.token else {
                throw GeneratorError.nodeConfiguration("Property generator couldn't parse incorrect subnodes configurations")
        }

        let nodeType = try TypeNodeParser().detectType(for: typeNode)
        return .init(entryName: value,
                     entityName: value.snakeCaseToCamelCase(),
                     typeName: TypeNameBuilder().buildString(for: nodeType, isOptional: isOptional, modelType: type),
                     fromInit: FromDTOBuilder().buildString(for: nodeType, with: value, isOptional: isOptional),
                     toDTOInit: ToDTOBuilder().buildString(for: nodeType, with: value, isOptional: isOptional))
    }

}

extension String {

    func formOptional(_ isOptional: Bool) -> String {
        return self + isOptional.keyWord
    }

}

extension Bool {

    var keyWord: String {
        return self ? "?" : ""
    }

}
