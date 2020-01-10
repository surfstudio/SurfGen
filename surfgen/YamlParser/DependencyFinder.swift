//
//  DependencyFinder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 09/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger

final class DependencyFinder {


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

    func findDependency(modelName: String, schemas: [ComponentObject<Schema>]) -> [String] {
        guard case let .object(object) = schemas.first(where: { $0.name == modelName })?.value.type else {
            return []
        }
        return object.properties.map { detectRefenrencies(for: $0.schema.type) }.flatMap { $0 }
    }

    func detectRefenrencies(for schemaType: SchemaType) -> [String] {
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
        default:
            return []
        }
    }

}
