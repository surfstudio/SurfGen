//
//  DependenciesFinderTests.swift
//  surfgenTests
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
@testable import YamlParser
import SwiftyJSON


class DependenciesFinderTests: XCTestCase {

    func testRendezvousDependecies() {
        let schemas = YamsParser().load(for: FileReader().readFile("rendezvous", "yaml")).schemas
        RendezvousModel.allCases.forEach { checkDependenciesFinder(for: $0, with: schemas) }
    }

    func checkDependenciesFinder(for model: RendezvousModel, with schemas: JSON){
        let modelName = model.rawValue
        let resultedModels = DependenciesFinder().findPlainDependencies(for: schemas, modelName: modelName)
        XCTAssertEqual(resultedModels, model.dependencies)
    }

}
