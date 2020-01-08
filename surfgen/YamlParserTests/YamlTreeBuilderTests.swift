//
//  YamlTreeBuilderTests.swift
//  YamlParserTests
//
//  Created by Mikhail Monakov on 08/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
@testable import YamlParser
import SwiftyJSON

class YamlTreeBuilderTests: XCTestCase {

    func testTree() {
        let schemas = YamsParser().load(for: FileReader().readFile("rendezvous", "yaml")).schemas
        let deps = DependenciesFinder().findPlainDependencies(for: schemas, modelName: "Profile")
        let test = try? YamlTreeBuilder().buildTree(from: schemas, models: Array(deps))

        if let root = test {
            let result = DependencyAnalyzer().analyze(declNodes: root.subNodes)
            let asd = GroupResolver().resolve(for: result.nodesToGenerate)
            print(asd)
        }

    }

}
