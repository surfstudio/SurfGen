//
//  SwaggerValidator.swift
//  
//
//  Created by Dmitry Demyanov on 02.02.2021.
//

import Foundation
import Common

/// This class keeps logic of determining if passed elements are correct in terms of OpenAPI Specification
/// It can also fix some of detected issues
/// All found issues are passed to the Logger
public class SwaggerValidator {

    private let logger: Logger?

    /// Works silently, without making warnings, if no `Logger` passed
    public init(logger: Logger? = nil) {
        self.logger = logger
    }

    /// Checks that `path` doesn't contain query string paramters
    /// If it does, removes them
    /// See https://swagger.io/docs/specification/paths-and-operations/#query-string-in-paths for details
    ///
    public func validatePath(_ path: String) -> String {
        // Query string in URL (if exists) follows "?" like `example.com/users?role=admin`
        if let questionMarkIndex = path.range(of: "?")?.lowerBound {
            logger?.warning("Path \(path) should not contain query string. Trying to fix...")
            return String(path.prefix(upTo: questionMarkIndex))
        }

        return path
    }
}
