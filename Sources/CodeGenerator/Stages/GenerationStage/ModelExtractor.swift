//
//  ModelExtractor.swift
//  
//
//  Created by Dmitry Demyanov on 14.01.2021.
//

import Common
import Foundation

public class ModelExtractor {
    
    public init() {
    }
    
    public func extractModels(from service: ServiceGenerationModel) -> [SchemaGenerationModel] {
        return service.paths.flatMap { $0.extractModels() }.uniqueElements()
    }
}

private extension SchemaType {
    
    func extractModels() -> [SchemaGenerationModel] {
        switch self {
        case .enum(let enumModel):
            return [.enum(enumModel)]
        case .object(let objectModel):
            return objectModel.extractModels()
        case .array(let arrayModel):
            return arrayModel.extractModels()
        case .group(let groupModel):
            return groupModel.extractModels()
        case .alias:
            return []
        }
    }
}

private extension SchemaArrayModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        switch itemsType {
        case .reference(let schemaType):
            return schemaType.extractModels()
        case .primitive:
            return []
        }
    }
}

private extension SchemaGroupModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        return references.flatMap { referenceType -> [SchemaGenerationModel] in
            switch referenceType {
            case .object(let objectModel):
                return objectModel.extractModels()
            case .group(let group):
                return group.extractModels()
            }
        }
    }
}

private extension PropertyModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        switch type {
        case .reference(let schemaType):
            return schemaType.extractModels()
        case .array(let arrayModel):
            return arrayModel.extractModels()
        case .primitive:
            return []
        }
    }
}

private extension SchemaObjectModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        return [.object(self)] + properties.flatMap { $0.extractModels() }
    }
}

private extension ParameterModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        switch type {
        case .reference(let schemaType):
            return schemaType.extractModels()
        case .array(let arrayModel):
            return arrayModel.extractModels()
        case .primitive:
            return []
        }
    }
}

private extension DataModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        switch type {
        case .object(let objectModel):
            return objectModel.extractModels()
        case .group(let groupModel):
            return groupModel.extractModels()
        case .array(let arrayModel):
            return arrayModel.extractModels()
        }
    }
}

private extension RequestModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        return content.flatMap { $0.extractModels() }
    }
}

private extension ResponseModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        return values.flatMap { $0.extractModels() }
    }
}

private extension OperationModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        return
            (parameters ?? []).flatMap { $0.value.extractModels() }
            + (responses ?? []).flatMap { $0.value.extractModels() }
            + (requestModel?.value.extractModels() ?? [])
    }
}

private extension ServiceModel {
    
    func extractModels() -> [SchemaGenerationModel] {
        return operations.flatMap { $0.extractModels() }
    }
}
