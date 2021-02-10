//
//  SurfGenError.swift
//
//
//  Created by Dmitry Demyanov on 17.11.2020.
//

import Foundation

/// Just a wrapper on other errors
/// Tha main feature is that whis error implemntation can print error tree with shifts
///
/// For example. If we have:
///
/// ```Swift
///
/// SurfGenError(nested: CustomError(message: "Can't parse `schema` inside `path` declaration"), message: "While parsing \(path)")
/// ```
///
/// The we will get:
///
/// ```
/// While parsing GET
///     Can't parse `schema` inside `path` declaration
/// ```
///
/// And for more comfortable wrapping there is a global `wrap` method
///
/// You should use `wrap` instead create this instance directly
///
/// ```Swift
///
/// wrap(
///     CustomError(message: "Can't parse `schema` inside `path` declaration"),
///     message: "While parsing \(path)"
/// )
/// ```
///
public struct SurfGenError: LocalizedError {

    let nested: Error
    let message: String

    public init(nested: Error, message: String) {
        self.nested = nested
        self.message = message
    }

    public var errorDescription: String? {
        return "\(self.message)\n\(nested.localizedDescription)".tabShifted()
    }

    public var rootError: Error {
        guard let nestedWrapper = nested as? SurfGenError else {
            return nested
        }
        return nestedWrapper.rootError
    }

}

public func wrap<T>(_ wraped: @autoclosure () throws -> T, message: String) throws -> T {
    do {
        return try wraped()
    } catch {
        throw SurfGenError(nested: error, message: message)
    }
}
