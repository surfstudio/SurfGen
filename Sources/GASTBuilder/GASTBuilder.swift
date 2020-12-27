//
//  Builder.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Yams
import Swagger
import Common
import GASTTree

public protocol GASTBuilder {
    func build(filePath: String) throws -> RootNode
}

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

    public func build(filePath: String) throws -> RootNode {

        let fileContent = try fileProvider.readTextFile(at: filePath)

        let spec = try wrap(SwaggerSpec(string: fileContent),
                            message: "Error occured while parsing spec at path \(filePath)")

        let schemas = try wrap(self.schemaBuilder.build(schemas: spec.components.schemas), message: "While parsing schemas for specification at path: \(filePath)")

        let parameters = try wrap(self.parameterBuilder.build(parameters: spec.components.parameters),
                                  message: "While parsing parameters for specification at path: \(filePath)")

        let services = try wrap(self.serviceBuilder.build(paths: spec.paths),
                                message: "While parsing services for specification at path: \(filePath)")

        let responses = try wrap(self.responsesBuilder.build(responses: spec.components.responses),
                                 message: "While parsing responses for specification at path: \(filePath)")

        let requestBodies = try wrap(self.requestBodiesBuilder.build(requestBodies:spec.components.requestBodies),
                                 message: "While parsing responses for specification at path: \(filePath)")

        return .init(
            schemas: schemas,
            parameters: parameters,
            services: services,
            requestBodies: requestBodies,
            responses: responses)
    }
}
