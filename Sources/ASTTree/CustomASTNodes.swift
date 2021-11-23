//
//  File.swift
//  
//
//  Created by Александр Кравченков on 25.10.2021.
//

import Foundation
import Swagger
import Common

public enum CustomASTNode {

    /// Creates a stub for schema
    /// Contains real name of stubbed node in `metadata.title`
    /// - SeeAlso: `Common.Constants.ASTNodeName`
    public static func makeTODOSchema(realName: String?) -> Schema {
        return Schema(
            metadata: .init(type: .string, title: realName),
            type: .string(.init(jsonDictionary: [:]))
        )
    }

    /// Create a stub for parameter
    /// Contains real name, location, description, required, example.
    public static func makeTODOParameter(real: Parameter) -> Parameter {
        return .init(
            name: real.name,
            location: real.location,
            description: real.description,
            required: real.required,
            example: real.example,
            type: .schema(
                ParameterSchema(
                    schema: self.makeTODOSchema(realName: nil),
                    serializationStyle: .simple,
                    explode: false
                )
            ),
            json: [:]
        )
    }
}
