//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Swagger
import Common
import GASTTree

extension Schema {
    func extractType() throws -> PropertyNode.PossibleType {
        switch self.type {
        case .any:
            throw CommonError(message: "Type is `any`, but we can process only primitive types, arrays and $ref")
        case .object:
            throw CommonError(message: "Type is `object`, but we can process only primitive types, arrays and $ref")
        case .group:
            throw CommonError(message: "Type is `group`, but we can process only primitive types, arrays and $ref")
        case .array(let arr):
            switch arr.items {
            case .multiple:
                throw CommonError(message: "Array conains multiple items declaration. So we can't process it now")
            case .single(let schema):
                let type = try schema.extractType()
                guard case .simple(let val) = type else {
                    throw CommonError(message: "Array conains single item with wrong type \(type). But we can process only primitive types and $ref in this case")
                }
                return .array(.init(itemsType: val))
            }
        case .reference(let ref):
            return .simple(.ref(ref.rawValue))
        case .boolean:
            return .simple(.entity(.boolean))
        case .string:
            return .simple(.entity(.string))
        case .number:
            return .simple(.entity(.number))
        case .integer:
            return .simple(.entity(.integer))
        }
    }
}

extension ParameterLocation {
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
