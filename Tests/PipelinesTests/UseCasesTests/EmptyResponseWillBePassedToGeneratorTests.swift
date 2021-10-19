//
//  EmptyResponseWillBePassedToGeneratorTests.swift
//  
//
//  Created by Александр Кравченков on 19.10.2021.
//

import Foundation
import XCTest
import CodeGenerator
import GASTTree
import UtilsForTesting

/// 1. Response with 201 code will be presented in operation
/// 2. Response with 204 code will be presented in operation
public final class EmptyResponseWillBePassedToGeneratorTests: XCTestCase {

    public func testResponseCreatedWillBePresentedInOPeration() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseEmptyBodyCreated,
        ]

        var result = [[PathModel]]()

        var factory = StubGASTTreeFactory(fileProvider: fileProvider, resultClosure: { result = $0 })
        factory.useNewNullableDeterminationStrategy = true
        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let response = result.first?.first?.operations.first?.responses?.first else {
            XCTFail("Response not found")
            return
        }

        guard case Reference<ResponseModel>.notReference(let respModel) = response else {
            XCTFail("Unexpected response")
            return
        }

        XCTAssertEqual(respModel.key, "201")
    }

    public func testResponseNoContentWillBePresentedInOPeration() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseEmptyBodyNoContent,
        ]

        var result = [[PathModel]]()

        var factory = StubGASTTreeFactory(fileProvider: fileProvider, resultClosure: { result = $0 })
        factory.useNewNullableDeterminationStrategy = true
        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let response = result.first?.first?.operations.first?.responses?.first else {
            XCTFail("Response not found")
            return
        }

        guard case Reference<ResponseModel>.notReference(let respModel) = response else {
            XCTFail("Unexpected response")
            return
        }

        XCTAssertEqual(respModel.key, "204")
    }
}
