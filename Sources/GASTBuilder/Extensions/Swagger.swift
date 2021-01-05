//
//  Swagger.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Swagger
import Common
import GASTTree

extension ParameterLocation {
    /// Converts `Swagger` parameters location to `SurfGen`
    ///
    /// ## Don't support
    ///
    /// ### `cookie` and `header` as parameter's location
    func convert() throws -> ParameterNode.Location {
        switch self {
        case .query:
            return .query
        case .path:
            return .path
        case .cookie, .header:
            throw CommonError(message: "We only support parameters whics is located in `query` and `path`")
        }
    }
}

extension SchemaType {
    var shortDescription: String {
        switch self {
        case .reference(let ref):
            return "$ref: \(ref.rawValue)"
        case .object:
            return "object"
        case .array:
            return "array"
        case .group:
            return "group"
        case .boolean:
            return "boolean"
        case .string:
            return "string"
        case .number:
            return "number"
        case .integer:
            return "integer"
        case .any:
            return "any"
        }
    }
}

extension GroupSchema.GroupType {
    var gast: SchemaGroupType {
        switch self {
        case .all:
            return .allOf
        case .one:
            return .oneOf
        case .any:
            return .anyOf
        }
    }
}
