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

    private lazy var rootGenerator: RootGenerator = {
        let templatesPath = Path(#file) + "../../../Templates/Swift"
        let rootGenerator = RootGenerator(tempatesPath: templatesPath, platform: .swift)
        rootGenerator.setServiceGenerator(ServiceGenerator.defaultGenerator(for: .swift))
        return rootGenerator
    }()

    /// Checks if generated services for Tricolor API are equal to expected ones
    func testFullTricolorApiGeneratedServicesMatchExpected() throws {
        for service in TricolorService.passingGenerationCases {
            try testFullServiceGeneration(for: service)
        }
    }

    /// Checks if spec with invalid paths fails to generate
    func testTricolorApiCatalogSpecIsDetectedAsInvalid() throws {
        // given
        let service = TricolorService.catalog
        let spec = FileReader().readFile(service.specPath)
        let parser = try YamlToGASTParser(string: spec)

        // then
        assertThrow(try parser.parseToGAST(forServiceRootPath: service.rootPath),
                    throws: GASTBuilderError.invalidPath(""))
    }

    /// Checks if spec with external parameters fails to generate
    func testTricolorApiExternalParametersAreDetectedAsInvalid() throws {
        for service in TricolorService.externalParametersCases {
            // given
            let spec = FileReader().readFile(service.specPath)
            let parser = try YamlToGASTParser(string: spec)

            // then
            assertThrow(try parser.parseToGAST(forServiceRootPath: service.rootPath),
                        throws: GASTBuilderError.invalidParameter(""))
        }
    }

    private func testFullServiceGeneration(for service: TricolorService) throws {
        // given
        let spec = FileReader().readFile(service.specPath)
        let parser = try YamlToGASTParser(string: spec)

        //when
        let gastTree = try parser.parseToGAST(forServiceRootPath: service.rootPath)
        let generatedService = try rootGenerator.generateService(name: service.rawValue, from: gastTree)

        // then
        for servicePart in generatedService {
            XCTAssertEqual(servicePart.value.fileName,
                           service.fileName(for: servicePart.key),
                           "File name is not equal to expected one. Resulted value:\n\(servicePart.value.fileName)")
            XCTAssertEqual(servicePart.value.code,
                           service.getCode(for: servicePart.key),
                           FileComparator().getDifference(for: service.getCode(for: servicePart.key),
                                                          expectedFile: servicePart.value.code))
        }
    }

}
