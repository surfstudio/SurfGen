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

/// Just an interface for any GAST-Service builder
public protocol ServiceBuilder {
    /// Build all item which are under `paths:`
    func build(paths: [Path]) throws -> [PathNode]
}

/// Default implementation for `ServiceBuilder`
/// 
/// Builds `path` elements of Open-API spec
///
/// **WARNING**
///
/// This struct cuts out response bodies without content. So if response doesn't have body then it will be just `nil`
///
/// - See: https://swagger.io/docs/specification/paths-and-operations/
///
/// - Todo: Parameters declared `in-pace` have `name` property set to empty string. May be it isn't good idea. It isn't affect code generation.
/// - Todo: In Swagger exists response key `default`. It's response wihout specific `httpCode`. Now we support it. But to honest. I don't like it. May be we need to throw a warning about this.
public struct AnyServiceBuilder: ServiceBuilder {

    let parameterBuilder: ParametersBuilder
    let schemaBuilder: SchemaBuilder
    let requestBodyBuilder: RequestBodyBuilder
    let responseBuilder: ResponseBuilder

    public init(parameterBuilder: ParametersBuilder,
                schemaBuilder: SchemaBuilder,
                requestBodyBuilder: RequestBodyBuilder,
                responseBuilder: ResponseBuilder) {
        self.parameterBuilder = parameterBuilder
        self.schemaBuilder = schemaBuilder
        self.requestBodyBuilder = requestBodyBuilder
        self.responseBuilder = responseBuilder
    }

    /// Build all item which are under `paths:`
    public func build(paths: [Path]) throws -> [PathNode] {
        return try paths.map { path in
            let parameters = try wrap(buildParameters(path.parameters),
                                      message: "While parsing path paramters for \(path.path)")
            let operations = try wrap(self.build(operations: path.operations),
                                      message: "While parsing Path: \(path.path)")
            return PathNode(path: path.path,
                            parameters: parameters,
                            operations: operations)
        }
    }
}

extension AnyServiceBuilder {
    func build(operations: [Swagger.Operation]) throws -> [OperationNode] {
        return try operations.map { operation in

            let params = try wrap(buildParameters(operation.parameters),
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

    func buildParameters(_ parameters: [PossibleReference<Parameter>]) throws -> [Referenced<ParameterNode>] {
        return try parameters.map {
            switch $0 {
            case .reference(let ref):
                return .ref(ref.rawValue)
            case .value(let val):
                let params = try wrap(
                    // TODO: - think about how to fix emty string
                    self.parameterBuilder.build(parameters: [.init(name: "", value: val)]),
                    message: "While parsing operation's parameter \(val.name)")

                guard params.count == 1 else {
                    throw CommonError(message: "We had sent 1 parameter, and then got \(params.count). It's very strange. Plz contact mainteiners")
                }

                return .entity(params[0])
            }
        }
    }

    func buildBody(body: PossibleReference<RequestBody>?) throws -> Referenced<RequestBodyNode>? {
        guard let body = body else { return nil }

        switch body {
        case .reference(let ref):
            return .ref(ref.rawValue)
        case .value(let val):
            let node = try self.requestBodyBuilder.build(requestBody: val)
            return .entity(node)
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

    func buildResponse(response: PossibleReference<Response>) throws -> Referenced<ResponseNode>? {
        switch response {
        case .reference(let ref):
            return .ref(ref.rawValue)
        case .value(let val):
            /// for example, in 204 reasponse content is empty
            guard val.content != nil else {
                return nil
            }
            return .entity(try self.responseBuilder.build(response: val))
        }
    }
}
