//
//  AnyRequestBodiesBuilder.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Swagger
import Common

/// Just an interface for any GAST-RequestBody builder
public protocol RequestBodyBuilder {
    func build(requestBody: RequestBody) throws -> RequestBodyNode
}

/// The same as `RequestBodyBuilder` can build bodies which are declared in `components.requestBodies`
public protocol RequestBodiesBuilder {
    func build(requestBodies: [ComponentObject<RequestBody>]) throws -> [ComponentRequestBodyNode]
}

/// Default implementation for both `RequestBodyBuilder` and `RequestBodiesBuilder`
///
/// _seems lke that it's the only one implementation which isn't contain some restrictions :D_
public struct AnyRequestBodiesBuilder: RequestBodiesBuilder, RequestBodyBuilder {

    public let mediaTypesBuilder: MediaTypesBuilder

    public init(mediaTypesBuilder: MediaTypesBuilder) {
        self.mediaTypesBuilder = mediaTypesBuilder
    }

    public func build(requestBodies: [ComponentObject<RequestBody>]) throws -> [ComponentRequestBodyNode] {
        return try requestBodies.map { requestBody -> ComponentRequestBodyNode in

            let value = try wrap(self.build(requestBody: requestBody.value),
                                 message: "While build request body \(requestBody.name)")

            return .init(name: requestBody.name, value: value)
        }
    }

    public func build(requestBody: RequestBody) throws -> RequestBodyNode {
        let content = try wrap(
            self.mediaTypesBuilder.buildMediaItems(items: requestBody.content.mediaItems),
            message: "While build media types")
        return .init(description: requestBody.description, content: content, isRequired: requestBody.required)
    }
}
