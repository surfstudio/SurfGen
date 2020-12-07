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
        let generatedRoute = try UrlRouteGenerator().generateCode(for: NodesBuilder.formTestServiceDeclarationNode(),
                                                              environment: environment)

        // then
        XCTAssertEqual(generatedRoute.fileName,
                       expectedFileName,
                       "File name is not equal to expected one. Resulted value:\n\(generatedRoute.fileName)")
        XCTAssertEqual(generatedRoute.code,
                       expectedCode,
                       "Code is not equal to expected one. Resulted value:\n\(generatedRoute.code)")
    }

    func testGeneratedServiceProtocolMatchesExpected() throws {
        // given
        let expectedCode = TestService.pet.getCode(for: .protocol)
        let expectedFileName = TestService.pet.fileName(for: .protocol)

        // when
        let generatedService = try ServiceGenerator().generateCode(for: NodesBuilder.formTestServiceDeclarationNode(),
                                                                   environment: environment)
        let generatedProtocol = generatedService.protocol

        // then
        XCTAssertEqual(generatedProtocol.fileName,
                       expectedFileName,
                       "File name is not equal to expected one. Resulted value:\n\(generatedProtocol.fileName)")
        XCTAssertEqual(generatedProtocol.code,
                       expectedCode,
                       "Code is not equal to expected one. Resulted value:\n\(generatedProtocol.code)")
    }

    func testGeneratedServiceImplementationMatchesExpected() throws {
        // given
        let expectedCode = TestService.pet.getCode(for: .service)
        let expectedFileName = TestService.pet.fileName(for: .service)

        // when
        let generatedService = try ServiceGenerator().generateCode(for: NodesBuilder.formTestServiceDeclarationNode(),
                                                                   environment: environment)
        let generatedImplementation = generatedService.service

        // then
        XCTAssertEqual(generatedImplementation.fileName,
                       expectedFileName,
                       "File name is not equal to expected one. Resulted value:\n\(generatedImplementation.fileName)")
        XCTAssertEqual(generatedImplementation.code,
                       expectedCode,
                       "Code is not equal to expected one. Resulted value:\n\(generatedImplementation.code)")
    }

}
