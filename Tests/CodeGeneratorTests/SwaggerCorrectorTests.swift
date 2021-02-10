//
//  SwaggerCorrectorTests.swift
//  
//
//  Created by Дмитрий on 03.02.2021.
//

import Foundation
import XCTest
import CodeGenerator

/// Contains cases which check that `SwaggerCorrector` finds expected issues in OpenAPI elements and, if possible, fixes them
class SwaggerCorrectorTests: XCTestCase {

    /// Checks that if path is already valid, corrector lefts it unchanged
    func correctPathIsLeftUnchanged() {
        // Arrange

        let correctPath = "/billings/service/{serviceId}"
        let corrector = SwaggerCorrector()

        // Act

        let validatedPath = corrector.correctPath(correctPath)

        // Assert

        XCTAssertEqual(correctPath, validatedPath)
    }

    /// Checks that if path contains query string, it is cut off
    func pathWithQueryStringIsRecognizedAndFixed() {
        // Arrange

        let pathWithQueryString = "/billings/service?serviceId={serviceId}"
        let expectedPath = "/billings/service"
        let corrector = SwaggerCorrector()

        // Act

        let correctedPath = corrector.correctPath(pathWithQueryString)

        // Assert

        XCTAssertEqual(expectedPath, correctedPath)
    }
}
