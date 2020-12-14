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

public protocol GASTBuilder {
    func build(filePath: String) throws -> RootNode
}

public struct AnyGASTBuilder: GASTBuilder {

    let fileProvider: FileProvider
    let schemaBuilder: SchemaBuilder

    public init(fileProvider: FileProvider, schemaBuilder: SchemaBuilder) {
        self.fileProvider = fileProvider
        self.schemaBuilder = schemaBuilder
    }

    public func build(filePath: String) throws -> RootNode {

        let fileContent = try fileProvider.readTextFile(at: filePath)

        let spec = try wrap(SwaggerSpec(string: fileContent),
                            message: "Error occured while parsing spec at path \(filePath)")

        let schemas = try wrap(self.schemaBuilder.build(schemas: spec.components.schemas), message: "While parsing compenents for specification at path: \(filePath)")

        return .init(schemas: schemas)
    }
}
