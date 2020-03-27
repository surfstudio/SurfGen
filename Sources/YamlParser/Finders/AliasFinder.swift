//
//  AliasFinder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 11/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger


final class AliasFinder {

    /**
     Method finds all Alias Models for primitive types for provided models (enum - is not a pritive type)

     Example of Alias Model:

     ```
     Promocode:
        type: string
        description: Промокод для скидки
        example: "123456"
     ```
     */
    func findAlaises(for schemas: [ComponentObject<Schema>]) -> [String: Schema] {
        let aliasModels = schemas.filter { $0.value.type.isPrimitive && !$0.isEnum }
        return Dictionary(uniqueKeysWithValues: zip(aliasModels.map { $0.name }, aliasModels.map { $0.value }))
    }

}


