//
//  SwaggerValidatorTests.swift
//  
//
//  Created by Дмитрий on 03.02.2021.
//

import Foundation
import XCTest
import CodeGenerator

/// Contains cases which check that `SwaggerValidator` finds expected issues in OpenAPI elements and, if possible, fixes them
class SwaggerValidatorTests: XCTestCase {

    /// Checks that if path is already valid, validator lefts it unchanged
    func correctPathIsLeftUnchanged() {
        // Arrange

        let correctPath = "/billings/service/{serviceId}"
        let validator = SwaggerValidator()

        // Act

        let validatedPath = validator.validatePath(correctPath)

        // Assert

        XCTAssertEqual(correctPath, validatedPath)
    }

    /// Checks that if path contains query string, it is cut off
    func pathWithQueryStringIsRecognizedAndFixed() {
        // Arrange

        let pathWithQueryString = "/billings/service?serviceId={serviceId}"
        let expectedPath = "/billings/service"
        let validator = SwaggerValidator()

        // Act

        let validatedPath = validator.validatePath(pathWithQueryString)

        // Assert

        XCTAssertEqual(expectedPath, validatedPath)
    }
}
