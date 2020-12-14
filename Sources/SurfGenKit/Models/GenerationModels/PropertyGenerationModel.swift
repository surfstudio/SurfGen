//
//  PropertyGenerationModel.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

public struct PropertyGenerationModel: Equatable {

    let entryName: String
    let type: String
    let entityName: String
    let fromInit: String
    let toDTOInit: String
    let isPlain: Bool // indicates that type is standard (Int, Bool) or its array of standard type
    let isOptional: Bool
    let description: String?

    init(entryName: String,
         entityName: String,
         typeName: String,
         fromInit: String,
         toDTOInit: String,
         isPlain: Bool,
         isOptional: Bool,
         description: String?) {
        self.entryName = entryName
        self.entityName = entityName
        self.type = typeName
        self.fromInit = fromInit
        self.toDTOInit = toDTOInit
        self.isPlain = isPlain
        self.isOptional = isOptional
        self.description = description
    }

}
