//
//  Utils.swift
//  
//
//  Created by Александр Кравченков on 19.12.2020.
//

import Foundation
import Common
import ReferenceExtractor
import GASTBuilder
import GASTTree
import Pipelines
import CodeGenerator

extension Reference where DataType == ParameterModel {
    var name: String {
        switch self {
        case .reference(let val):
            return val.name
        case .notReference(let val):
            return val.name
        }
    }

    func type() throws -> ParameterModel.PossibleType {
        switch self {
        case .notReference(let val):
            return val.type
        case .reference:
            throw CommonError.init(message: "It's reference not a primitive")
        }
    }

    func refType() throws -> ParameterModel.PossibleType {
        switch self {
        case .notReference:
            throw CommonError.init(message: "It's primitive not a reference")
        case .reference(let val):
            return val.type
        }
    }
}

extension ParameterModel.PossibleType {
    func primitiveType() throws -> PrimitiveType {
        switch self {
        case .primitive(let val):
            return val
        case .reference(let ref):
            throw CommonError(message: "The parameter's type is reference \(ref)")
        case .array(let val):
            throw CommonError(message: "The parameter's type is array \(val)")
        }
    }

    func notPrimitiveType() throws -> SchemaType {
        switch self {
        case .primitive(let val):
            throw CommonError(message: "The parameter's type is primitive: \(val)")
        case .reference(let val):
            return val
        case .array(let val):
            throw CommonError(message: "The parameter's type is array \(val)")
        }
    }
}

extension PropertyModel.PossibleType {

    func arrayType() throws -> SchemaArrayModel {
        switch self {
        case .primitive(let val):
            throw CommonError(message: "The property type is primitive: \(val)")
        case .reference(let val):
            throw CommonError(message: "The property type is reference \(val)")
        case .array(let val):
            return val
        }
    }
}
