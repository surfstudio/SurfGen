//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import Common
import GASTTree

public struct ResponseBodyParser {

    public let mediaTypeParser: MediaTypeParser

    public init(mediaTypeParser: MediaTypeParser) {
        self.mediaTypeParser = mediaTypeParser
    }

    public func build(responses: [OperationNode.ResponseBody], current: DependencyWithTree, other: [DependencyWithTree]) throws -> [Reference<ResponseModel, ResponseModel>] {
        return try responses.map { response in
            switch response.response {
            case .entity(let val):
                let values = try wrap(
                    self.build(response: val, current: current, other: other),
                    message: "While parsing response \(response.key)"
                )
                return .notReference(.init(key: response.key, values: values))
            case .ref(let val):
                throw CustomError.notInplemented()
            }
        }
    }

    func build(response: ResponseNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> [DataModel] {
        return try response.content.map { mediaType in
            return try self.mediaTypeParser.parse(mediaType: mediaType, current: current, other: other)
        }
    }
}
