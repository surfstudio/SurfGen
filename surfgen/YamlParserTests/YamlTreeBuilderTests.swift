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


            if case let .object(object) = spec.components.schemas.first?.value.type {
                for property in object.properties {
                    switch property.schema.type {
                    case .reference(let reference):
                        dump(reference)
                    default: continue
                    }
                }
            }

        } catch {
            dump(error.localizedDescription)
        }


    }

}
