//
//  RootNode.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Common

public struct RootNode {
    public var schemas: [SchemaObjectNode]
    public var parameters: [ParameterNode]
    public var requestBodies: [ComponentRequestBodyNode]
    public var responses: [ComponentResponseNode]
    public var services: [PathNode]

    public init(schemas: [SchemaObjectNode],
                parameters: [ParameterNode],
                services: [PathNode],
                requestBodies: [ComponentRequestBodyNode],
                responses: [ComponentResponseNode]) {
        self.schemas = schemas
        self.parameters = parameters
        self.services = services
        self.requestBodies = requestBodies
        self.responses = responses
    }
}

extension RootNode {
    /// Awaits `#/components/schemas|parameters|responses|requestBodies/ModelName`
    public func resolve<T>(reference: String) throws -> T {
        let splited = reference.split(separator: "/")

        if splited.count != 4 {
            throw CustomError(
                message: "Reference for resolving should contains 4 components splited by `/` but \(reference) contains \(splited.count)"
            )
        }

        if splited[1] != "components" {
            throw CustomError(
                message: "Reference for resolving should contains `components` as second components of path. But \(reference) doesn't"
            )
        }

        switch splited[2] {
        case "schemas":
            let res = try self.resolveSchema(name: String(splited[3]))

            guard let found = res else {
                throw CustomError(message: "\(splited[3]) not found in this tree")
            }

            guard let casted = found as? T else {
                throw CustomError(message: "Couldn't cast \(found) to \(T.self)")
            }

            return casted
        case "parameters":
            let res = try self.resolveParameter(name: String(splited[3]))

            guard let found = res else {
                throw CustomError(message: "\(splited[3]) not found in this tree")
            }

            guard let casted = found as? T else {
                throw CustomError(message: "Couldn't cast \(found) to \(T.self)")
            }

            return casted
        case "responses":
            let res = try self.resolveResponses(name: String(splited[3]))

            guard let found = res else {
                throw CustomError(message: "\(splited[3]) not found in this tree")
            }

            guard let casted = found as? T else {
                throw CustomError(message: "Couldn't cast \(found) to \(T.self)")
            }

            return casted
        case "requestBodies":
            let res = try self.resolveRequestBodies(name: String(splited[3]))

            guard let found = res else {
                throw CustomError(message: "\(splited[3]) not found in this tree")
            }

            guard let casted = found as? T else {
                throw CustomError(message: "Couldn't cast \(found) to \(T.self)")
            }

            return casted
        default:
            throw CustomError(
                message: "Reference for resolving should contains `sahemas` or `parameters` as thrid components of path. But \(reference) doesn't"
            )
        }
    }

    func resolveSchema(name: String) throws -> Any? {
        return try self.schemas.first { schema -> Bool in
            switch schema.next {
            case .object(let val):
                return val.name == name
            case .enum(let val):
                return val.name == name
            case .simple(let val):
                return val.name == name
            case .reference:
                throw CustomError(message: "\(name) is refrence. Now reference which is referenced to another reference is unsupported")
            }
        }
    }

    func resolveParameter(name: String) throws -> Any? {
        return self.parameters.first(where: { param -> Bool in
            return param.componentName == name
        })
    }

    func resolveRequestBodies(name: String) throws -> Any? {
        self.requestBodies.first(where: { reqBody in
            reqBody.name == name
        })
    }

    func resolveResponses(name: String) throws -> Any? {
        self.responses.first(where: { reqBody in
            reqBody.name == name
        })
    }
}

extension RootNode: StringView {
    public var view: String {
        return "Root:\n\tSchemas:\n\t\t\(schemas.view)\n\nParameters:\(parameters)"
    }
}
