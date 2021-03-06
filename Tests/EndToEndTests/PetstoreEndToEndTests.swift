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

    private let spec = FileReader().readFile("TestFiles/Petstore/petstore.yaml")

    private lazy var rootGenerator: RootGenerator = {
        let templatesPath = Path(#file) + "../../../Templates/Swift"
        let rootGenerator = RootGenerator(tempatesPath: templatesPath, platform: .swift)
        rootGenerator.setServiceGenerator(ServiceGenerator.defaultGenerator(for: .swift))
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
        let gastTree = try parser.parseToGAST(forServiceRootPath: service.rawValue)
        let generatedService = try rootGenerator.generateService(name: service.rawValue,
                                                                 from: gastTree,
                                                                 parts: ServicePart.allCases)

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
