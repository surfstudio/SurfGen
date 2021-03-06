//
//  Templates.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

enum Template {
    case nodeKitEntity(entityName: String, entryName: String, properties: [PropertyGenerationModel], description: String)
    case nodeKitEntry(className: String, properties: [PropertyGenerationModel], description: String)
    case `enum`(EnumGenerationModel)
    case urlRoute(ServiceGenerationModel)
    case serviceProtocol(ServiceGenerationModel)
    case service(ServiceGenerationModel)

    var fileName: String {
        switch self {
        case .nodeKitEntity:
            return "Entity.txt"
        case .nodeKitEntry:
            return "Entry.txt"
        case .enum:
            return "Enum.txt"
        case .urlRoute:
            return "UrlRoute.txt"
        case .serviceProtocol:
            return "ServiceProtocol.txt"
        case .service:
            return "Service.txt"
        }
    }

    var context: [String: Any] {
        switch self {
        case .enum(let enumModel):
            return [
                "description": enumModel.description,
                "enumName": enumModel.enumName,
                "enumType": enumModel.enumType,
                "cases": enumModel.cases
            ]
        case .nodeKitEntry(let className, let properties, let description):
            return [
                "description": description,
                "className": className,
                "properties": properties,
                "isPlain": properties.allSatisfy { $0.isPlain }
            ]
        case .nodeKitEntity(let entityName, let entryName, let properties, let description):
            return [
                "description": description,
                "entityName": entityName,
                "entryName": entryName,
                "properties": properties,
                "isPlain": properties.allSatisfy { $0.isPlain }
            ]
        case .urlRoute(let serviceModel),
             .serviceProtocol(let serviceModel),
             .service(let serviceModel):
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
