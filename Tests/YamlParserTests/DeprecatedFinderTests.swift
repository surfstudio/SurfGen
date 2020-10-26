//
//  DeprecatedFinderTests.swift
//  
//
//  Created by Dmitry Demyanov on 18.10.2020.
//

import XCTest
@testable import YamlParser
import Swagger

class DeprecatedFinderTests: XCTestCase {

    func testPetstoreDeprecatedPaths() {
        do {
            let spec = try SwaggerSpec(string: FileReader().readFile("TestFiles/petstore.yaml"))
            PetstoreService.allCases.forEach { checkDeprecatedFinder(for: $0, with: spec.paths) }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func checkDeprecatedFinder(for service: TestService, with paths: [Path]) {
        let pathsWithoutDeprecated = paths.filter { service.matchingPaths.contains($0.path) }
                                          .flatMap { $0.operations }
                                          .apply { DeprecatedFinder().removeDeprecated(from: $0) }
                                          .map { $0.path }
        XCTAssertEqual(Set(pathsWithoutDeprecated), service.pathsWithoutDeprecated)
    }

}
