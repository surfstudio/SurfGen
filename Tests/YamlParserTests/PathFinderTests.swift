//
//  PathFinderTests.swift
//  YamlParserTests
//
//  Created by Dmitry Demyanov on 17.10.2020.
//

import XCTest
@testable import YamlParser
import Swagger

class PathFinderTests: XCTestCase {

    func testRendezvousPaths() {
        do {
            let spec = try SwaggerSpec(string: FileReader().readFile("TestFiles/rendezvous.yaml"))
            RendezvousService.allCases.forEach { checkPathFinder(for: $0, with: spec.paths) }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func testPetstorePaths() {
        do {
            let spec = try SwaggerSpec(string: FileReader().readFile("TestFiles/petstore.yaml"))
            PetstoreService.allCases.forEach { checkPathFinder(for: $0, with: spec.paths) }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func checkPathFinder(for service: TestService, with paths: [Path]){
        let serviceName = service.rawValue
        let matchingPaths = PathFinder().findMatchingPaths(from: paths, for: serviceName).map { $0.path }
        XCTAssertEqual(Set(matchingPaths), service.matchingPaths)
    }

}
