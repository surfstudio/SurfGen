//
//  AnyParametersBuilder.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Common
import Swagger
import GASTTree

/// Just an interface for any GAST-Parameter builder
public protocol ParametersBuilder {
    /// Can build `parameter`
    func build(parameters: [ComponentObject<Parameter>]) throws -> [ParameterNode]
}

/// Default implementation for `ParametersBuilder`.
/// 
/// Can build parameters both from `components.parameters` and from `paths.operations.parameters`
///
/// - See: https://swagger.io/docs/specification/describing-parameters/
///
/// ## Don't support
///
/// ### Content in paramter's type. You cant declare `schema` in parameter's type
///
/// For example it's **ok**:
///
/// ```YAML
///  Param1:
///     type: integer
///
///  Param2:
///     type:
///         $ref: "..."
/// ```
/// But it's **not**
///
/// ```YAML
///  Param1:
///     type:
///         content:
///             type: object
///             ....
/// ```
public struct AnyParametersBuilder: ParametersBuilder {

    private let schemaBuilder: SchemaBuilder

    public init(schemaBuilder: SchemaBuilder) {
        self.schemaBuilder = schemaBuilder
    }

    public func build(parameters: [ComponentObject<Parameter>]) throws -> [ParameterNode] {

        return try parameters.map { parameter -> ParameterNode in

            let loc = try wrap(parameter.value.location.convert(),
                           message: "While parsing parameter \(parameter.name)")

            let type = try wrap(self.parse(type: parameter.value.type),
                                message: "While parsing parameter \(parameter.name)")

            return ParameterNode(
                componentName: parameter.name,
                name: parameter.value.name,
                location: loc,
                description: parameter.value.description,
                type: type,
                isRequired: parameter.value.required)
        }
    }
}

extension AnyParametersBuilder {

    private func parse(type: ParameterType) throws -> ParameterTypeNode {
        switch type {
        case .content:
            throw CommonError(message: "We don't support `content` parameter's type")
        case .schema(let schema):


            // TODO: - Remove it
            // because this method provides possiblity to parse parameters types as any schema
            // or add tests for this class for each type of parameter's type

            let schemas = try self.schemaBuilder.build(schemas: [.init(name: "", value: schema.schema)], apiDefinitionFileRef: "")

            guard schemas.count == 1 else {
                throw CommonError(message: "After parsing parameter's schema we got \(schemas.count) modles. But awaiting only 1. Please create an issue and attach your swagger specification")
            }

            return .init(schema: schemas[0])
        }
    }
}
