//
//  SwaggerCorrectorTests.swift
//  
//
//  Created by Дмитрий on 03.02.2021.
//

import Foundation
import XCTest
import Pipelines
import UtilsForTesting

@testable import CodeGenerator

/// Contains cases which check that `SwaggerCorrector` finds expected issues in OpenAPI elements and, if possible, fixes them
class SwaggerCorrectorTests: XCTestCase {

    /// Checks that if path is already valid, corrector lefts it unchanged
    func testCorrectPathIsLeftUnchanged() {
        // Arrange

        let correctPath = "/billings/service/{serviceId}"
        let corrector = SwaggerCorrector()

        // Act

        let validatedPath = corrector.correctPath(correctPath)

        // Assert

        XCTAssertEqual(correctPath, validatedPath)
    }

    /// Checks that if path contains query string, it is cut off
    func testPathWithQueryStringIsRecognizedAndFixed() {
        // Arrange

        let pathWithQueryString = "/billings/service?serviceId={serviceId}"
        let expectedPath = "/billings/service"
        let corrector = SwaggerCorrector()

        // Act

        let correctedPath = corrector.correctPath(pathWithQueryString)

        // Assert

        XCTAssertEqual(expectedPath, correctedPath)
    }

    /// Checks that if path parameters are declared in `Operation` instead of `Path`, corrector moves them to `Path`
    func testPathParametersDeclaredInOperationAreMovedToPath() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: SwaggerCorrectorYamls.yamlWithPathParametersInOperationWontBeParsed]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)
        var result = [[PathModel]]()
        factory.resultClosure = { (val: [[PathModel]]) throws -> Void in
            result = val
        }
        let pipeline = factory.build()

        let corrector = SwaggerCorrector()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)
        let fixedParameters = corrector.correctPathParameters(for: result[0][0])

        // Assert

        XCTAssertEqual(fixedParameters.count, 1)
        XCTAssertEqual(fixedParameters.first?.value.name, "id")
    }

}
