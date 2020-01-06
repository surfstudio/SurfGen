//
//  DependencyAnalyzerTests.swift
//  YamlParserTests
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
@testable import YamlParser
import SwiftyJSON

extension RendezvousModel {

    var primitiveDependencies: [String: String] {
        switch self {
        case .products:
            return ["Id": "string", "FurStatus": "integer", "Money": "string"]
        case .geoPos, .searchHint:
            return [:]
        }
    }

    var dependenciesToGenerate: Set<String> {
        switch self {
        case .products:
            return  ["ProductsResponse", "ProductShort", "Metadata", "Color"]
        case .geoPos:
            return ["GeoPosition"]
        case .searchHint:
            return ["ExpandProductsData", "SearchHint"]
        }
    }

}

class DependencyAnalyzerTests: XCTestCase {

    func testDependencyAnalyzer() {
        let schemas = YamsParser().load(for: FileReader().readFile("rendezvous", "yaml")).schemas
        RendezvousModel.allCases.forEach {
            let dependeciesToAnalyze = DependenciesFinder().findPlainDependencies(for: schemas, modelName: $0.rawValue)
            let result = DependencyAnalyzer().analyze(dependencies: dependeciesToAnalyze,
                                                      for: schemas)
            XCTAssertEqual(result.dependenciesToGenerate, $0.dependenciesToGenerate)

            XCTAssertEqual(result.primitiveDependencies, $0.primitiveDependencies)
        }

    }

}
