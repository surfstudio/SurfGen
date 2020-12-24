//
//  Templates.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

enum Template {
    case entity(entityName: String, entryName: String, properties: [PropertyGenerationModel], description: String)
    case entry(className: String, properties: [PropertyGenerationModel], description: String)
    case `enum`(EnumGenerationModel)
    case service(ServiceGenerationModel)

    var context: [String: Any] {
        switch self {
        case .enum(let enumModel):
            return [
                "description": enumModel.description,
                "enumName": enumModel.enumName,
                "enumType": enumModel.enumType,
                "cases": enumModel.cases
            ]
        case .entry(let className, let properties, let description):
            return [
                "description": description,
                "className": className,
                "properties": properties,
                "isPlain": properties.allSatisfy { $0.isPlain }
            ]
        case .entity(let entityName, let entryName, let properties, let description):
            return [
                "description": description,
                "entityName": entityName,
                "entryName": entryName,
                "properties": properties,
                "isPlain": properties.allSatisfy { $0.isPlain }
            ]
        case .service(let serviceModel):
            return [
                "name": serviceModel.name,
                "hasKeys": serviceModel.hasKeys,
                "keys": serviceModel.keys,
                "paths": serviceModel.paths,
                "operations": serviceModel.operations
            ]
        }
    }

}
