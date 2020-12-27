//
//  AnyServiceBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Common
import Swagger
import GASTTree

public protocol ServiceBuilder {
    func build(paths: [Path]) throws -> [PathNode]
}

public struct AnyServiceBuilder: ServiceBuilder {

    let parameterBuilder: ParametersBuilder
    let schemaBuilder: SchemaBuilder

    public init(parameterBuilder: ParametersBuilder, schemaBuilder: SchemaBuilder) {
        self.parameterBuilder = parameterBuilder
        self.schemaBuilder = schemaBuilder
    }

    public func build(paths: [Path]) throws -> [PathNode] {
        return try paths.map { path in
            let operations = try wrap(self.build(operations: path.operations),
                                      message: "While parsing Path: \(path)")
            return PathNode(path: path.path, operations: operations)
        }
    }
}

extension AnyServiceBuilder {
    func build(operations: [Swagger.Operation]) throws -> [OperationNode] {
        return try operations.map { operation in

            let mapper = { (param: PossibleReference<Parameter>) -> Referenced<ParameterNode> in
                switch param {
                case .reference(let ref):
                    return .ref(ref.rawValue)
                case .value(let val):
                    let params = try wrap(
                        // TODO: - think about how to fix emty string
                        self.parameterBuilder.build(parameters: [.init(name: "", value: val)]),
                        message: "While parsing operation's parameter \(val.name)")

                    guard params.count == 1 else {
                        throw CustomError(message: "We had sent 1 parameter, and then got \(params.count). It's very strange. Plz contact mainteiners")
                    }

                    return .entity(params[0])
                }
            }

            let params = try wrap(operation.parameters.map(mapper),
                                  message: "While parsing operation \(operation.method.rawValue)")

            let requestBody = try wrap(
                self.buildBody(body: operation.requestBody),
                message: "While parsing requestBody for operation \(operation.method.rawValue)")

            let responses = try wrap(
                self.buildOperationResponses(responses: operation.responses),
                message: "While parsing responses for operation \(operation.method.rawValue)")

            return .init(method: operation.method.rawValue,
                         description: operation.description,
                         summary: operation.summary,
                         parameters: params,
                         requestBody: requestBody,
                         responses: responses)
        }
    }

    func buildBody(body: PossibleReference<RequestBody>?) throws -> Referenced<RequestBodyNode>? {
        guard let body = body else { return nil }

        switch body {
        case .reference(let ref):
            return .ref(ref.rawValue)
        case .value(let val):
            let content = try self.buildMediaItems(items: val.content.mediaItems)
            return .entity(.init(description: val.description, content: content, isRequired: val.required))
        }
    }

    func buildOperationResponses(responses: [OperationResponse]) throws -> [OperationNode.ResponseBody] {
        return try responses.map { response -> OperationNode.ResponseBody in
            let builtResponse = try self.buildResponse(response: response.response)
            let key = { () -> String in
                guard let statusCode = response.statusCode else {
                    return "default"
                }
                return "\(statusCode)"
            }()
            return .init(key: key, response: builtResponse)
        }
    }

    func buildResponse(response: PossibleReference<Response>) throws -> Referenced<ResponseNode> {
        switch response {
        case .reference(let ref):
            return .ref(ref.rawValue)
        case .value(let val):
            guard let rawContent = val.content else {
                throw CustomError(message: "SurfGen doesn't support responeses without content")
            }
            let content = try self.buildMediaItems(items: rawContent.mediaItems)
            return .entity(.init(description: val.description, content: content))
        }
    }

    func buildMediaItems(items: [String: MediaItem]) throws -> [MediaTypeObjectNode] {
        return try items.map { key, value -> MediaTypeObjectNode in
            let schema = try wrap(
                self.schemaBuilder.build(schemas: [.init(name: "", value: value.schema)]),
                message: "While build request body")

            guard schema.count == 1 else {
                throw CustomError(message: "We had sent 1 schema, and then got \(schema.count). It's very strange. Plz contact mainteiners")
            }

            return MediaTypeObjectNode(typeName: key, schema: schema[0])
        }
    }
}
