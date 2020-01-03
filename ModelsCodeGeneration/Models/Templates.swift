//
//  Templates.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

enum Template {
    case nodeKitEntity(entityName: String, entryName: String, properties: [PropertyGenerationModel])
    case nodeKitEntry(className: String, properties: [PropertyGenerationModel])

    var fileName: String {
        switch self {
        case .nodeKitEntity:
            return "EntityDTOConvertable.txt"
        case .nodeKitEntry:
            return "EntryCodable.txt"
        }
    }

    var context: [String: Any] {
        switch self {
        case .nodeKitEntry(let className, let properties):
            return [
                "className": className,
                "properties": properties
            ]
        case .nodeKitEntity(let entityName, let entryName, let properties):
            return [
                "entityName": entityName,
                "entryName": entryName,
                "codeOpenBracket": KeyWords.codeStartBracket,
                "properties": properties,
                "isPlain": properties.first { !$0.isPlain } == nil
            ]
        }
    }

}
