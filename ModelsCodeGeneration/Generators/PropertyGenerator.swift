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
    
    init(name: String, typeName: String, type: Type, isOptional: Bool) {
        self.type = typeName
        entryName = name
        entityName = name.snakeCaseToCamelCase()
        
        switch type {
        case .plain(let value):
            fromInit = "model.\(value)"
            toDTOInit = entityName
        case .object:
            toDTOInit = "try \(entityName).toDTO()"
            fromInit = ".from(dto: model.\(entryName))"
        case .array(let subType):
            switch subType {
            case .plain(let value):
                fromInit = "model.\(value)"
                toDTOInit = entityName
            default:
                
                
            }
            fromInit = "model."
        }
    }

}

public class ToDTOBuilder {

    func
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
        return .init(name: value, type: "\(typeName)\(isOptional.keyWord)", isStandardType: isStandard)
    }

}

extension Bool {
    
    var keyWord: String {
        return self ? "?" : ""
    }

}
