//
//  YamlTreeBuilderTests.swift
//  YamlParserTests
//
//  Created by Mikhail Monakov on 08/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
@testable import YamlParser
import Swagger

class YamlTreeBuilderTests: XCTestCase {

    func testTree() {
//        let schemas = YamsParser().load(for: ).schemas
//        let deps = DependenciesFinder().findPlainDependencies(for: schemas, modelName: "Profile")
//
//        do {
//            let test = try YamlTreeBuilder().buildTree(from: schemas)
//            dump(test)
//        } catch {
//            dump(error)
//        }
        do {
            let spec = try SwaggerSpec(string: FileReader().readFile("rendezvous", "yaml"))

//            let tmp = DependencyFinder().findDependencies(for: spec.components.schemas, modelName: "ProductsResponse")
            if let schema = spec.components.schemas.first(where: { $0.name == "ProductCart" }), case let .group(object) = schema.value.type {
                let test = AliasResolver().findProperties(for: schema.value)
                print(test.0.map { ($0.name, $0.required) })
            }

//            print(tmp.map { $0.name })
        } catch {
            dump(error.localizedDescription)
        }
    }

    

}
