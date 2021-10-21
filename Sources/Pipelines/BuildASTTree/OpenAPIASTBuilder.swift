//
//  OpenAPIASTBuilder.swift
//  
//
//  Created by Александр Кравченков on 21.10.2021.
//

import Foundation
import Common
import Swagger

/// Reads all YAML files from dependencies array and parse them to Swagger AST Tree
/// Then you can do with this AST whatever you want
/// - SeeAlso: `OpenAPIASTTree`
public struct OpenAPIASTBuilder: PipelineStage {

    public typealias Input = [Dependency]

    public let next: AnyPipelineStage<[OpenAPIASTTree]>
    public let fileProvider: FileProvider

    public init(fileProvider: FileProvider, next: AnyPipelineStage<[OpenAPIASTTree]>) {
        self.fileProvider = fileProvider
        self.next = next
    }

    public func run(with input: [Dependency]) throws {
        var pathesToFiles = Set<String>()

        // make uniq set of pathes

        input.forEach { dependency in
            pathesToFiles.update(with: dependency.pathToCurrentFile)
            dependency.dependecies.values.forEach { pathesToFiles.update(with: $0) }
        }

        // now we have all pathes (to OpenAPI files) which are used by our dependencies
        // and withous doubles

        // so just parse that files to SwaggerSpec and save in dictionary where key is path to current file
        // we will use path later to recreate [Dependency] but now with AST

        let pathAndAstDict = try pathesToFiles.reduce(into: [String: SwaggerSpec](), { dict, path in

            let content = try wrap(
                self.fileProvider.readTextFile(at: path),
                message: "While reading file to build OpenAPI AST"
            )

            let spec = try wrap(
                SwaggerSpec(string: content),
                message: "While building OpenAPI AST"
            )

            dict[path] = spec
        })

        // recreation

        let depTrees = try input.map { dependency -> OpenAPIASTTree in

            let err = CommonError(message: "While creating forest from OpenAPI AST we have inconsistency in data. Please contant us with error log")

            guard let currentTree = pathAndAstDict[dependency.pathToCurrentFile] else {
                throw err
            }

            let dependencies = try dependency.dependecies.reduce(into: [String : SwaggerSpec]()) { result, kv in
                let (key, value) = kv

                guard let tree = pathAndAstDict[value] else {
                    throw err
                }

                result[key] = tree
            }


            return OpenAPIASTTree(dependencies: dependencies, currentTree: currentTree, rawDependency: dependency)
        }

        // now we have [OpenAPIASTTree] which is similar to [Dependencies] that we got

        try self.next.run(with: depTrees)
    }
}
