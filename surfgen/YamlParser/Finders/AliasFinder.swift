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
     Method finds all Alias Models for primitive types for provided models
     */
    func findAlaises(for schemas: [ComponentObject<Schema>]) -> [String: Schema] {
        let aliasModels = schemas.filter { $0.value.type.isPrimitive }
        return Dictionary(uniqueKeysWithValues: zip(aliasModels.map { $0.name }, aliasModels.map { $0.value }))
    }

}


