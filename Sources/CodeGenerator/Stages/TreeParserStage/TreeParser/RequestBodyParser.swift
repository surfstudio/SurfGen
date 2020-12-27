//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Common

public struct RequestBodyParser {

    public let mediaTypeParser: MediaTypeParser

    public init(mediaTypeParser: MediaTypeParser) {
        self.mediaTypeParser = mediaTypeParser
    }

    public func parse(requestBody: Referenced<RequestBodyNode>,
                      current: DependencyWithTree,
                      other: [DependencyWithTree]) throws -> Reference<RequestModel, RequestModel> {
        switch requestBody {
        // it's when we have declaration of request in operation. like this:
        // requestBody:
        //   content:
        //      application/json:
        //          schema:
        //              type: object
        case .entity(let val):
            return .notReference(try self.parse(bodyNode: val, current: current, other: other))

        // it's when we have ref on declaration
        // requestBody:
        //   $ref: "#/components/requestBodies"
        case .ref(let ref):
            throw CustomError.notInplemented()
        }
    }

    func parse(bodyNode: RequestBodyNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> RequestModel {

        let content = try bodyNode.content.map { mediaType in
            return try wrap(
                self.mediaTypeParser.parse(mediaType: mediaType, current: current, other: other),
                message: "While parsing MediaType \(mediaType.typeName)"
            )
        }

        return .init(
            description: bodyNode.description,
            content: content,
            isRequired: bodyNode.isRequired
        )
    }
}

