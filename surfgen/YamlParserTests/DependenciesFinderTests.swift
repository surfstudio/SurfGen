//
//  DependenciesFinderTests.swift
//  surfgenTests
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
@testable import YamlParser
import Swagger

class DependenciesFinderTests: XCTestCase {

    func testRendezvousDependecies() {
        do {
            let spec = try SwaggerSpec(string: FileReader().readFile("rendezvous", "yaml"))
            RendezvousModel.allCases.forEach { checkDependenciesFinder(for: $0, with: spec.components.schemas) }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func checkDependenciesFinder(for model: RendezvousModel, with schemas: [ComponentObject<Schema>]){
        let modelName = model.rawValue
        let resultedModels = DependencyFinder().findDependencies(for: schemas, modelName: modelName)
        XCTAssertEqual(Set(resultedModels.map { $0.name }), model.dependencies)

        for model in resultedModels {
            if model.value.type.isPrimitive {
                dump(model.name)
            }
        }
    }

}
