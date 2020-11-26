//
//  PetstoreTests.swift
//  
//
//  Created by Dmitry Demyanov on 12.11.2020.
//

import XCTest
import Swagger
import PathKit
@testable import YamlParser
@testable import SurfGenKit

class PetstoreEndToEndTests: XCTestCase {

    let spec = FileReader().readFile("TestFiles/petstore.yaml")

    lazy var rootGenerator: RootGenerator = {
        let templatesPath = Path(#file) + "../../../Templates"
        let rootGenerator = RootGenerator(tempatesPath: templatesPath)
        rootGenerator.configureServiceGenerator(ServiceGenerator.defaultGenerator)
        return rootGenerator
    }()

    /// Checks if generated services for Petstore API are equal to expected ones
    func testFullPetstoreApiGeneratedServicesMatchExpected() throws {
        for service in PetstoreService.allCases {
            try testFullServiceGeneration(for: service)
        }
    }

    private func testFullServiceGeneration(for service: PetstoreService) throws {
        // given
        let parser = try YamlToGASTParser(string: spec)

        //when
        let gastTree = try parser.parseToGAST(forService: service.rawValue)
        let generatedService = try rootGenerator.generateService(from: gastTree)

        // then
        for servicePart in generatedService {
            XCTAssertEqual(servicePart.value.fileName,
                           service.fileName(for: servicePart.key),
                           "File name is not equal to expected one. Resulted value:\n\(servicePart.value.fileName)")
            XCTAssertEqual(servicePart.value.code,
                           service.getCode(for: servicePart.key),
                           "Code is not equal to expected one. Resulted value:\n\(servicePart.value.code)")
        }
    }

}
