//
//  SurfGenError.swift
//  
//
//  Created by Dmitry Demyanov on 17.11.2020.
//

import Foundation

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

public func wrap<T>(_ wraped: @autoclosure () throws -> T, with msg: String) throws -> T {
    do {
        return try wraped()
    } catch {
        throw SurfGenError(nested: error, message: msg)
    }
}
