//
//  ParametersSchemaBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Swagger
import Common

public struct ParametersSchemaBuilder {
    public func build(schema: ParameterSchema) throws -> ParameterSchemaNode {
        switch schema.schema.type {
        case .object(_): // TODO: Support
            throw CustomError(message: "Type `object` is unsupported for parameter's schems. Create an issue or vote for existed one")
        case .array(_): // TODO: Support
            throw CustomError(message: "Type `array` is unsupported for parameter's schems. Create an issue or vote for existed one")
        case .group(_): // TODO: Support
            throw CustomError(message: "Type `group` is unsupported for parameter's schems. Create an issue or vote for existed one")
        case .any:
            throw CustomError(message: "Type `any` is unsupported for parameter's schema. Create an issue or vote for existed one")
        case .reference(let ref):
            return .init(next: .ref(ref.rawValue))
        case .boolean:
            return .init(next: .simple(.boolean))
        case .string(_):
            return .init(next: .simple(.string))
        case .number(_):
            return .init(next: .simple(.number))
        case .integer(_):
            return .init(next: .simple(.integer))
        }
    }
}
