//
//  PathFinderTests.swift
//  YamlParserTests
//
//  Created by Dmitry Demyanov on 17.10.2020.
//

import XCTest
@testable import YamlParser
import Swagger

/// Tests for grouping paths in separate services
class PathFinderTests: XCTestCase {

    /// Checks if Rendez-vouz API paths are splitted into services as expected
    func testRendezvousPathsToServiceMatching() throws {
        let spec = try SwaggerSpec(string: FileReader().readFile("TestFiles/rendezvous.yaml"))
        RendezvousService.allCases.forEach { checkPathFinder(for: $0, with: spec.paths) }
    }

    /// Checks if PetstoreAPI paths are splitted into services as expected
    func testPetstorePathsToServiceMatching() throws {
        let spec = try SwaggerSpec(string: FileReader().readFile("TestFiles/petstore.yaml"))
        PetstoreService.allCases.forEach { checkPathFinder(for: $0, with: spec.paths) }
    }

    private func checkPathFinder(for service: TestService, with paths: [Path]){
        // given
        let serviceName = service.rawValue
        
        // when
        let matchingPaths = PathFinder().findMatchingPaths(from: paths, for: serviceName).map { $0.path }
        
        // then
        XCTAssertEqual(Set(matchingPaths), service.matchingPaths)
    }

}
