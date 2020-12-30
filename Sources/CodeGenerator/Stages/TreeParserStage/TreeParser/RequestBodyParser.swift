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
            let parsed = try wrap(
                self.parse(ref: ref, current: current, other: other),
                message: "While resolving \(ref) from file \(current.dependency.pathToCurrentFile)"
            )
            return .reference(parsed)
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

    func parse(ref: String, current: DependencyWithTree, other: [DependencyWithTree]) throws -> RequestModel {
        let splited = ref.split(separator: "#")

        var dependency = current
        var refToResolve = ref

        if splited.count == 2 {
            // it means that this is a ref to another file
            dependency = try Resolver().resolveRefToAnotherFile(ref: ref, node: current, other: other)
            refToResolve = "#\(splited[1])"
        }

        // there is can not be reference cycle between requestBodies

        let resolved: ComponentRequestBodyNode = try dependency.tree.resolve(reference: refToResolve)

        return try wrap(
            self.parse(bodyNode: resolved.value, current: dependency, other: other),
            message: "While parsing resolved \(resolved.name) which is located in \(dependency.dependency.pathToCurrentFile)")
    }
}

