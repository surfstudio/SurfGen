//
//  AliasReplacer.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger

final class AliasReplacer {

    /**
     Method finds all cases of references objects which are in the aliases dictionary and replaces these references
     with concreate types
     */
    func replace(for models: [ComponentObject<Schema>], aliases: [String: Schema]) -> [ComponentObject<Schema>] {
        var proccessedModels = [ComponentObject<Schema>]()
        for model in models {
            guard let object = model.value.type.object else {
                proccessedModels.append(model)
                continue
            }
            let proccessedRequiredProperties = object.requiredProperties.map { tranform(property: $0, aliases: aliases) }
            let proccessedOptionalProperties = object.optionalProperties.map { tranform(property: $0, aliases: aliases) }

            let newObject = ObjectSchema(requiredProperties: proccessedRequiredProperties,
                                         optionalProperties: proccessedOptionalProperties,
                                         properties: proccessedRequiredProperties + proccessedOptionalProperties ,
                                         minProperties: object.minProperties,
                                         maxProperties: object.maxProperties,
                                         additionalProperties: object.additionalProperties,
                                         abstract: object.abstract,
                                         discriminator: object.discriminator)
            let newModel = Schema(metadata: model.value.metadata,
                                  type: .object(newObject))
            proccessedModels.append(ComponentObject(name: model.name, value: newModel))
        }
        return proccessedModels
    }

    private func tranform(property: Property, aliases: [String: Schema]) -> Property {
        guard let ref = property.schema.type.reference, let aliasSchema = aliases[ref.name] else {
            return property

        }
        return .init(name: property.name, required: property.required,
                     schema: aliasSchema)
    }

}
