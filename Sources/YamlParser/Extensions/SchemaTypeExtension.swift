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
            return "boolean"
        case .string:
            return "string"
        case .number:
            return "number"
        case .integer:
           return "integer"
        default:
            return nil
        }
    }

    var modelName: String? {
        if case let .reference(ref) = self {
            return ref.name
        } else {
            return typeName
        }
    }

    var description: String {
        switch self {
        case .any:
            return "any"
        case .array(let array):
            return "array of \(array.items)"
        case .boolean:
            return "boolean"
        case .group(let group):
            return "group of \(group.type)"
        case .object(let object):
            return "object of \(object)"
        case .reference(let ref):
            return "refenerence of \(ref.name)"
        case .string(let string):
            return "string of \(string)"
        case .number(let number):
            return "string of \(number)"
        case .integer(let integer):
            return "string of \(integer)"
        }
    }

}
