//
//  DependencyFinder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 09/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger

final class DependencyFinder {

    /**
        Method finds all recursive dependencies for model with modelName value.

     ```
     ProductsResponse:
        properties:
            products:
                type: array
                items:
                    $ref: "#/components/schemas/ProductShort"
            metadata:
                    $ref: "#/components/schemas/Metadata"
     ```
      For yaml snippet above method will return  ["FurStatus", "Money", "ProductsResponse", "Id", "Color", "Metadata", "ProductShort"] compent schemas
         because ProductShort and Metadata contain dependencies too (see YamlParserTests/TestFiles/rendezvous.yaml file). So in order our models to be consistent we find all models that are required (even thought models such Id may be String type after we detect its in Id model in schemas).
     */
    func findDependencies(for schemas: [ComponentObject<Schema>], modelName: String) -> [ComponentObject<Schema>] {
        var dependencies: Set<String> = [modelName]
        var dependenciesToFind = [modelName]

        repeat {
            let foundDependencies = dependenciesToFind.map { findDependency(modelName: $0, schemas: schemas) }.flatMap { $0 }
            dependenciesToFind = foundDependencies.filter { !dependencies.contains($0) }
            foundDependencies.forEach { dependencies.insert($0) }
        } while !dependenciesToFind.isEmpty

        return schemas.filter { dependencies.contains($0.name) }
    }

    private func findDependency(modelName: String, schemas: [ComponentObject<Schema>]) -> [String] {
        guard let schemaType = schemas.first(where: { $0.name == modelName })?.value.type else {
            return []
        }

        return detectRefenrencies(for: schemaType)
    }

    private func detectRefenrencies(for schemaType: SchemaType) -> [String] {
        switch schemaType {
        case .reference(let reference):
            return [reference.name]
        case .array(let arraySchema):
            switch arraySchema.items {
            case .single(let schema):
                return detectRefenrencies(for: schema.type)
            case .multiple(let schemas):
                return schemas.map { detectRefenrencies(for: $0.type) }.flatMap { $0 }
            }
        case .group(let groupSchema):
            guard groupSchema.type == .all else { return [] }
            return groupSchema.schemas.compactMap { $0.type.object?.properties }
                .flatMap { $0 }
                .map { detectRefenrencies(for: $0.schema.type) }
                .flatMap { $0 }
        case .object(let objectSchema):
            return objectSchema.properties.map { detectRefenrencies(for: $0.schema.type) }.flatMap { $0 }
        default:
            return []
        }
    }

}
