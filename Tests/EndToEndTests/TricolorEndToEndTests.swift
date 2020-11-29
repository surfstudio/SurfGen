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
        let templatesPath = Path(#file) + "../../../Templates"
        let rootGenerator = RootGenerator(tempatesPath: templatesPath)
        rootGenerator.configureServiceGenerator(ServiceGenerator.defaultGenerator)
        return rootGenerator
    }()

    /// Checks if generated services for Tricolor API are equal to expected ones
    func testFullTricolorApiGeneratedServicesMatchExpected() throws {
        for service in TricolorService.passingGenerationCases {
            if service == .catalog {
                try testFullServiceGeneration(for: service)
            }
        }
    }

    /// Checks if spec with invalid paths fails to generate
    func testTricolorApiCatalogSpecIsDetectedAsInvalid() throws {
        // given
        let service = TricolorService.catalog
        let spec = FileReader().readFile(service.specPath)
        let parser = try YamlToGASTParser(string: spec)

        // then
        assertThrow(try parser.parseToGAST(forService: service.serviceName),
                    throws: GASTBuilderError.invalidPath(""))
    }

    /// Checks if spec with external parameters fails to generate
    func testTricolorApiExternalParametersAreDetectedAsInvalid() throws {
        for service in TricolorService.externalParametersCases {
            // given
            let spec = FileReader().readFile(service.specPath)
            let parser = try YamlToGASTParser(string: spec)

            // then
            assertThrow(try parser.parseToGAST(forService: service.serviceName),
                        throws: GASTBuilderError.invalidParameter(""))
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
            print(servicePart.value.code)
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
