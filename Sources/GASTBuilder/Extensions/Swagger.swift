//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Swagger
import Common

extension Schema {
    func extractType() throws -> PropertyNode.PossibleType {
        switch self.type {
        case .any:
            throw CustomError(message: "Type is `any`, but we can process only primitive types, arrays and $ref")
        case .object:
            throw CustomError(message: "Type is `object`, but we can process only primitive types, arrays and $ref")
        case .group:
            throw CustomError(message: "Type is `group`, but we can process only primitive types, arrays and $ref")
        case .array(let arr):
            switch arr.items {
            case .multiple:
                throw CustomError(message: "Array conains multiple items declaration. So we can't process it now")
            case .single(let schema):
                let type = try schema.extractType()
                guard case .simple(let val) = type else {
                    throw CustomError(message: "Array conains single item with wrong type \(type). But we can process only primitive types and $ref in this case")
                }
                return .array(.init(itemsType: val))
            }
        case .reference(let ref):
            return .simple(.ref(ref.rawValue))
        case .boolean:
            return .simple(.entity("boolean"))
        case .string:
            return .simple(.entity("string"))
        case .number:
            return .simple(.entity("number"))
        case .integer:
            return .simple(.entity("integer"))
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
            throw CustomError(message: "We only support parameters whics is located in `query` and `path`")
        }
    }
}
