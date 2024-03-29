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

    private let resolver: Resolver

    public init(mediaTypeParser: MediaTypeParser, resolver: Resolver) {
        self.mediaTypeParser = mediaTypeParser
        self.resolver = resolver
    }

    public func parse(responses: [OperationNode.ResponseBody], current: DependencyWithTree, other: [DependencyWithTree]) throws -> [Reference<ResponseModel>] {
        return try responses.map { response in

            guard let respValue = response.response else {
                return .notReference(.init(key: response.key, values: []))
            }

            switch respValue {
            case .entity(let val):
                let values = try wrap(
                    self.parse(response: val, current: current, other: other),
                    message: "While parsing response \(response.key)"
                )
                return .notReference(.init(key: response.key, values: values))
            case .ref(let val):
                let values = try wrap(
                    self.parse(ref: val, current: current, other: other),
                    message: "While resolving \(val) from \(current.dependency.pathToCurrentFile)"
                )
                return .reference(.init(key: response.key, values: values))
            }
        }
    }

    func parse(response: ResponseNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> [DataModel] {
        return try response.content.map { mediaType in
            return try self.mediaTypeParser.parse(mediaType: mediaType, current: current, other: other)
        }
    }

    func parse(ref: String, current: DependencyWithTree, other: [DependencyWithTree]) throws -> [DataModel] {
        let splited = ref.split(separator: "#")

        var dependency = current
        var refToResolve = ref

        if splited.count == 2 {
            // it means that this is a ref to another file
            dependency = try resolver.resolveRefToAnotherFile(ref: ref, node: current, other: other)
            refToResolve = "#\(splited[1])"
        }

        // there is can not be reference cycle between requestBodies

        let resolved: ComponentResponseNode = try dependency.tree.resolve(reference: refToResolve)

        return try wrap(
            self.parse(response: resolved.value, current: dependency, other: other),
            message: "While parsing resolved \(resolved.name) which is located in \(dependency.dependency.pathToCurrentFile)")
    }
}
