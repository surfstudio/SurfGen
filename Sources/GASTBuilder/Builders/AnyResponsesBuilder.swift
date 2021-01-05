//
//  AnyResponsesBuilder.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Swagger
import Common

/// Just an interface for any GAST-response builder
public protocol ResponseBuilder {
    func build(response: Response) throws -> ResponseNode
}

/// The same as `ResponseBuilder` but can build `components.responses`
public protocol ResponsesBuilder {
    func build(responses: [ComponentObject<Response>]) throws -> [ComponentResponseNode]
}

/// Default implementation of both `ResponseBuilder` and `ResponsesBuilder`
///
/// - See: https://swagger.io/docs/specification/describing-responses/
///
/// ## Don't support
///
/// ### Response body without content. They are mapped to `nil`
public struct AnyResponsesBuilder: ResponsesBuilder, ResponseBuilder {

    public let mediaTypesBuilder: MediaTypesBuilder

    public init(mediaTypesBuilder: MediaTypesBuilder) {
        self.mediaTypesBuilder = mediaTypesBuilder
    }

    public func build(responses: [ComponentObject<Response>]) throws -> [ComponentResponseNode] {
        return try responses.map { response -> ComponentResponseNode in

            let value = try wrap(self.build(response: response.value),
                                 message: "While build response \(response.name)")

            return .init(name: response.name, value: value)
        }
    }

    public func build(response: Response) throws -> ResponseNode {

        guard let responseContent = response.content else {
            throw CommonError(message: "SurfGen doesn't support response body without content")
        }

        let content = try wrap(
            self.mediaTypesBuilder.buildMediaItems(items: responseContent.mediaItems),
            message: "While build media types")

        return .init(description: response.description, content: content)
    }
}
