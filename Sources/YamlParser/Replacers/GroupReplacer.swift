//
//  GroupReplacer.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger

final class GroupReplacer {

    /**
     Method replaces all group nodes with object nodes which are generated using PropertiesFinder for all group references
     */
    func replace(for schemas: [ComponentObject<Schema>]) -> [ComponentObject<Schema>] {
        return schemas.map(transfrom)
    }

    private func transfrom(groupComponent: ComponentObject<Schema>) -> ComponentObject<Schema> {
        guard case .group = groupComponent.value.type else {
            return groupComponent
        }

        let (required, optional) = PropertiesFinder().findProperties(for: groupComponent.value)
        let object = ObjectSchema(requiredProperties: required,
                                  optionalProperties: optional,
                                  properties: required + optional)

        return ComponentObject(name: groupComponent.name, value: Schema(metadata: .init(), type: .object(object)))
    }

}
