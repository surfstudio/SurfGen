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
        var dependencies = Set<String>()

        var dependenciesToFind = [modelName]

        repeat {
            let foundDependencies = dependenciesToFind.map { findDependency(modelName: $0, schemas: schemas) }.flatMap { $0 }
            dependenciesToFind = foundDependencies.filter { !dependencies.contains($0) }
            foundDependencies.forEach { dependencies.insert($0) }
        } while !dependenciesToFind.isEmpty

        return schemas.filter { dependencies.contains($0.name) }
    }

    func findDependency(modelName: String, schemas: [ComponentObject<Schema>]) -> [String] {
        guard let model = schemas.first(where: { $0.name == modelName }) else {
            return []
        }

        if case let .object(object) = model.value.type {
            
        }

        return []

    }

}
