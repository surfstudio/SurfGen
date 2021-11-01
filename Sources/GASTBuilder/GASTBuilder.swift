//
//  GASTBuilder.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Swagger
import Common
import GASTTree
import ASTTree


/// Just an interface for any `GAST` builder
public protocol GASTBuilder {
    func build(astTree: OpenAPIASTTree) throws -> RootNode
}

/// Parse `API specification` to `OpenAPI-AST` then build the `GAST` from it.
///
/// It's a composition of different builders
/// This object just read file, build OpenAPI-AST with help of `Swagger` lib
/// And then run different builders for different spec's components to make `GAST`
///
/// - Note: Some builders contains some validation logic
public struct AnyGASTBuilder: GASTBuilder {

    let fileProvider: FileProvider
    let schemaBuilder: SchemaBuilder
    let parameterBuilder: ParametersBuilder
    let serviceBuilder: ServiceBuilder
    let responsesBuilder: ResponsesBuilder
    let requestBodiesBuilder: RequestBodiesBuilder

    public init(fileProvider: FileProvider,
                schemaBuilder: SchemaBuilder,
                parameterBuilder: ParametersBuilder,
                serviceBuilder: ServiceBuilder,
                responsesBuilder: ResponsesBuilder,
                requestBodiesBuilder: RequestBodiesBuilder) {
        self.fileProvider = fileProvider
        self.schemaBuilder = schemaBuilder
        self.parameterBuilder = parameterBuilder
        self.serviceBuilder = serviceBuilder
        self.responsesBuilder = responsesBuilder
        self.requestBodiesBuilder = requestBodiesBuilder
    }

    /// Create GAST from spec file
    public func build(astTree: OpenAPIASTTree) throws -> RootNode {

        let schemas = try wrap(
            self.schemaBuilder.build(schemas: astTree.currentTree.components.schemas),
            message: "While parsing schemas for specification at path: \(astTree.rawDependency.pathToCurrentFile)"
        )

        let parameters = try wrap(
            self.parameterBuilder.build(parameters: astTree.currentTree.components.parameters),
            message: "While parsing parameters for specification at path: \(astTree.rawDependency.pathToCurrentFile)"
        )

        let services = try wrap(
            self.serviceBuilder.build(paths: astTree.currentTree.paths),
            message: "While parsing services for specification at path: \(astTree.rawDependency.pathToCurrentFile)"
        )

        let responses = try wrap(
            self.responsesBuilder.build(responses: astTree.currentTree.components.responses),
            message: "While parsing responses for specification at path: \(astTree.rawDependency.pathToCurrentFile)"
        )

        let requestBodies = try wrap(
            self.requestBodiesBuilder.build(requestBodies: astTree.currentTree.components.requestBodies),
            message: "While parsing responses for specification at path: \(astTree.rawDependency.pathToCurrentFile)"
        )

        return .init(
            schemas: schemas,
            parameters: parameters,
            services: services,
            requestBodies: requestBodies,
            responses: responses
        )
    }
}
