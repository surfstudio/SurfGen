//
//  Templates.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

enum Template {
    case nodeKitEntity(entityName: String, entryName: String, properties: [PropertyGenerationModel], description: String)
    case nodeKitEntry(className: String, properties: [PropertyGenerationModel])
    case `enum`(EnumGenerationModel)

    var fileName: String {
        switch self {
        case .nodeKitEntity:
            return "EntityDTOConvertable.txt"
        case .nodeKitEntry:
            return "EntryCodable.txt"
        case .enum:
            return "CodableEnum.txt"
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
        case .nodeKitEntry(let className, let properties):
            return [
                "className": className,
                "properties": properties
            ]
        case .nodeKitEntity(let entityName, let entryName, let properties, let description):
            return [
                "description": description,
                "entityName": entityName,
                "entryName": entryName,
                "codeOpenBracket": "{",
                "properties": properties,
                "isPlain": properties.first { !$0.isPlain } == nil
            ]
        }
    }

}
