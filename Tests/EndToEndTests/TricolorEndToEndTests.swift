//
//  TricolorEndToEndTests.swift
//
//
//  Created by Dmitry Demyanov on 21.11.2020.
//

import XCTest
import Swagger
import PathKit
@testable import YamlParser
@testable import SurfGenKit

class TricolorEndToEndTests: XCTestCase {

    lazy var rootGenerator: RootGenerator = {
        let templatesPath = Path(#file) + "../../../Templates"
        return RootGenerator(tempatesPath: templatesPath)
    }()

    /// Checks if generated services for Tricolor API are equal to expected ones
    func testFullTricolorApiGeneratedServicesMatchExpected() throws {
        for service in TricolorService.allCases {
            try testFullServiceGeneration(for: service)
        }
    }

    private func testFullServiceGeneration(for service: TricolorService) throws {
        // given
        let spec = FileReader().readFile(service.specPath)
        let parser = try YamlToGASTParser(string: spec)

        //when
        let gastTree = try parser.parseToGAST(forService: service.serviceName)
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
