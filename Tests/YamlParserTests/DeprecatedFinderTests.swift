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

    /// Checks if paths dont't contain ones with ony deprecated operations after using DeprecatedFinder
    func testPetstoreDeprecatedPathsAreFiltered() throws {
        let spec = try SwaggerSpec(string: FileReader().readFile("TestFiles/petstore.yaml"))
        PetstoreService.allCases.forEach { checkDeprecatedFinder(for: $0, with: spec.paths) }
    }

    func checkDeprecatedFinder(for service: TestService, with paths: [Path]) {
        // when
        let pathsWithoutDeprecated = paths.filter { service.matchingPaths.contains($0.path) }
                                          .flatMap { $0.operations }
                                          .apply { DeprecatedFinder().removeDeprecated(from: $0) }
                                          .map { $0.path }
        
        // then
        XCTAssertEqual(Set(pathsWithoutDeprecated), service.pathsWithoutDeprecated)
    }

}
