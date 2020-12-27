//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Swagger
import Common

public protocol ResponsesBuilder {
    func build(responses: [ComponentObject<Response>]) throws -> [ComponentResponseNode]
}

public struct AnyResponsesBuilder: ResponsesBuilder {

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

    func build(response: Response) throws -> ResponseNode {

        guard let responseContent = response.content else {
            throw CustomError(message: "SurfGen doesn't support response body without content")
        }


        let content = try wrap(
            self.mediaTypesBuilder.buildMediaItems(items: responseContent.mediaItems),
            message: "While build media types")

        return .init(description: response.description, content: content)
    }
}
