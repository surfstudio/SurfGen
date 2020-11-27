//
//  ServiceGenerationTests.swift
//  
//
//  Created by Dmitry Demyanov on 13.11.2020.
//

import XCTest
@testable import SurfGenKit
import PathKit
import Stencil

/// Tests for generating full service code from prepared GAST tree
class ServiceGenerationTests: XCTestCase {

    let serviceGenerator = ServiceGenerator.defaultGenerator

    var environment: Environment {
        let path = Path(#file) + "../../../../Templates"
        let loader = FileSystemLoader(paths: [path])
        return Environment(loader: loader)
    }

    func testGeneratedUrlRouteMatchesExpected() throws {
        // given
        let expectedCode = TestService.pet.getCode(for: .urlRoute)
        let expectedFileName = TestService.pet.fileName(for: .urlRoute)

        // when
        let generatedService = try serviceGenerator.generateCode(for: NodesBuilder.formTestServiceDeclarationNode(),
                                                                   environment: environment)
        guard let generatedRoute = generatedService[.urlRoute] else {
            XCTFail("Route was not generated")
            return
        }

        // then
        XCTAssertEqual(generatedRoute.fileName,
                       expectedFileName,
                       "File name is not equal to expected one. Resulted value:\n\(generatedRoute.fileName)")
        XCTAssertEqual(generatedRoute.code,
                       expectedCode,
                       FileComparator().getDifference(for: generatedRoute.code, expectedFile: expectedCode))
    }

    func testGeneratedServiceProtocolMatchesExpected() throws {
        // given
        let expectedCode = TestService.pet.getCode(for: .protocol)
        let expectedFileName = TestService.pet.fileName(for: .protocol)

        // when
        let generatedService = try ServiceGenerator.defaultGenerator.generateCode(for: NodesBuilder.formTestServiceDeclarationNode(),
                                                                                  environment: environment)

        guard let generatedProtocol = generatedService[.protocol] else {
            XCTFail("Protocol was not generated")
            return
        }

        // then
        XCTAssertEqual(generatedProtocol.fileName,
                       expectedFileName,
                       "File name is not equal to expected one. Resulted value:\n\(generatedProtocol.fileName)")
        XCTAssertEqual(generatedProtocol.code,
                       expectedCode,
                       FileComparator().getDifference(for: generatedProtocol.code, expectedFile: expectedCode))
    }

    func testGeneratedServiceImplementationMatchesExpected() throws {
        // given
        let expectedCode = TestService.pet.getCode(for: .service)
        let expectedFileName = TestService.pet.fileName(for: .service)

        // when
        let generatedService = try ServiceGenerator.defaultGenerator.generateCode(for: NodesBuilder.formTestServiceDeclarationNode(),
                                                                                  environment: environment)
        guard let generatedImplementation = generatedService[.service] else {
            XCTFail("Service was not generated")
            return
        }

        // then
        XCTAssertEqual(generatedImplementation.fileName,
                       expectedFileName,
                       "File name is not equal to expected one. Resulted value:\n\(generatedImplementation.fileName)")
        XCTAssertEqual(generatedImplementation.code,
                       expectedCode,
                       FileComparator().getDifference(for: generatedImplementation.code, expectedFile: expectedCode))
    }

}
