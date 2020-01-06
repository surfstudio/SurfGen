//
//  DependenciesFinder.swift
//  surfgen
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON


/**
 Class for finding dependecies in json structure which were resulted from yaml format
 */
final class DependenciesFinder {

    /**
     Method finds unique model names which contains in generating model properties or its dependent models properties
     Method finds only plain dependencies which means that these dependencies are required as complete models (not only its properties
     like in "allOf" case).

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
      For yaml snippet above method will return  ["FurStatus", "Money", "ProductsResponse", "Id", "Color", "Metadata", "ProductShort"]
         because ProductShort and Metadata contain dependencies too (see YamlParserTests/TestFiles/rendezvous.yaml file). So in order our models to be consistent we find all models that are required (even thought models such Id may be String type after we detect its in Id model in schemas).
     */

    func findPlainDependencies(for schemas: JSON, modelName: String) -> Set<String> {
        var dependencies: Set<String> = [modelName]

        var dependenciesToFind = [modelName]
        repeat {
            let foundDependencies = dependenciesToFind.map { findDependentModels(for: schemas[$0]) }.flatMap { $0 }
            dependenciesToFind = foundDependencies.filter { !dependencies.contains($0) }
            foundDependencies.forEach { dependencies.insert($0) }
        } while !dependenciesToFind.isEmpty

        return dependencies
    }

    private func findDependentModels(for json: JSON) -> [String] {
        guard let properties = json.properties else { return [] }

        var dependenceModels = [String]()

        for property in properties {
            if let ref = property.value.refModel {
                dependenceModels.append(ref)
                continue
            }

            if let ref = property.value["items"].refModel {
                dependenceModels.append(ref)
                continue
            }
        }
        return dependenceModels
    }

}
