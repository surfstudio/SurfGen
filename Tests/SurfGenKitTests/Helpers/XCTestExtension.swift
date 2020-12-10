//
//  XCTestExtension.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 02/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
import SurfGenKit

extension XCTestCase {
    // https://www.swiftbysundell.com/posts/testing-error-code-paths-in-swift
    func assertThrow<T, E: Error & Equatable>(
        _ expression: @autoclosure () throws -> T,
        throws error: E,
        in file: StaticString = #file,
        line: UInt = #line
        ) {
        var thrownError: Error?

        XCTAssertThrowsError(try expression(),
                             file: file, line: line) {
                                thrownError = $0
        }

        guard let errorContainer = thrownError as? SurfGenError else {
            XCTFail("Unknown error type")
            return
        }

        XCTAssertTrue(
            errorContainer.rootError is E,
            "Unexpected error type: \(type(of: thrownError))",
            file: file, line: line
        )

        XCTAssertEqual(
            errorContainer.rootError as? E, error,
            file: file, line: line
        )
    }

}
