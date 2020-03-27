//
//  ComponentObjectExtension.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/03/2020.
//

import Swagger

extension ComponentObject where T == Schema {

    var isEnum: Bool {
        return value.metadata.enumValues != nil
    }

}
