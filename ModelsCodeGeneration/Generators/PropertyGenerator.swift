//
//  PropertyGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 03/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public struct PropertyGenerationModel: Equatable {
    var entryName: String
    var type: String
    var entityName: String

    var fromInit: String
    var toDTOInit: String
    
    public init(name: String, type: String, isStandardType: Bool) {
        self.type = type
        entryName = name
        entityName = name.snakeCaseToCamelCase()
    
        fromInit = isStandardType ? "model.\(entryName)" : ".from(dto: model.\(entryName))"
        toDTOInit = isStandardType ? entityName : "try \(entityName).toDTO()"
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
            case let .type(name) = typeNode.token else {
                throw GeneratorError.nodeConfiguration("Property generator couldn't parse incorrect subnodes configurations")
        }
        let isStandard = StandardTypes.all.contains(name)
        let typeName = isStandard ? name : type.formName(with: name)
        return .init(name: value, type: "\(typeName)\(isOptional.keyWord)", isStandardType: isStandard)
    }

}

extension Bool {
    
    var keyWord: String {
        return self ? "?" : ""
    }

}
