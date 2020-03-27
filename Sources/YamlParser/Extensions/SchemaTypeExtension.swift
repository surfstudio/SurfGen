//
//  SchemaTypeExtension.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger

extension SchemaType {

    var typeName: String? {
        switch self {
        case .boolean:
            return "Bool"
        case .string:
            return "String"
        case .number:
            return "Double"
        case .integer:
           return "Int"
        default:
            return nil
        }
    }

}
