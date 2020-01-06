//
//  DependencyAnalyzer.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON

final class DependencyAnalyzer {

    /**
    After DependenciesFinder finds plain dependencies we need to separate "fake" dependecies from primite types

     ```
     schemas:

     FeedComponent:
        properties:
            id:
                $ref: "#/components/schemas/Id"

     ...

     Id:
          description: Уникальный идентификатор
          type: string

     ```

     In that case object "Id: is referred to as "fake" object ("id: $ref: "#/components/schemas/Id"") but for parsing it will be simple
     "id: string" type. So in this method we detect real models and also create dictionary in order to replace "fake" links to hidden types
     while generatgin G-AST
    */

    func analyze(dependencies: Set<String>, for schemas: JSON) -> (dependenciesToGenerate: Set<String>, primitiveDependencies: [String: String]) {
        var dependenciesToGenerate = Set<String>()
        var primitiveDependecies = [String: String]()
        for dependency in dependencies {
            guard
                [schemas[dependency].properties,
                 schemas[dependency].allOf,
                 schemas[dependency].oneOf].lazy.first(where: { $0 != nil }) != nil else {
                    primitiveDependecies[dependency] = schemas[dependency].type
                    continue
            }
            dependenciesToGenerate.insert(dependency)
        }
        return (dependenciesToGenerate, primitiveDependecies)
    }

}
