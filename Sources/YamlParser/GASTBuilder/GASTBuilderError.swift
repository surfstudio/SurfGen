//
//  GASTBuilderError.swift
//  AEXML
//
//  Created by Mikhail Monakov on 12/03/2020.
//

import Foundation
import Swagger

enum GASTBuilderError: Error, Equatable {
    case undefinedTypeForField(String)
    case nonObjectNodeFound(String)
    case incorrectEnumObjectConfiguration(String)
    case undefindedContentBody(String)
    case invalidPath(String)
    case invalidParameter(String)

    public static func ==(lhs: GASTBuilderError, rhs: GASTBuilderError) -> Bool {
        switch (lhs, rhs) {
        case (.undefinedTypeForField, .undefinedTypeForField),
             (.nonObjectNodeFound, .nonObjectNodeFound),
             (.incorrectEnumObjectConfiguration, .incorrectEnumObjectConfiguration),
             (.invalidPath, .invalidPath),
             (.invalidParameter, .invalidParameter):
            return true
        default:
            return false
        }
    }
}

extension GASTBuilderError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .undefinedTypeForField(let type):
            return "Can not resolve type for provided SchemaType which is type of \(type)"
        case .nonObjectNodeFound(let name):
            return "Can not find object in provided Component object with name: \(name)"
        case .incorrectEnumObjectConfiguration(let name):
            return "Enum object with name: \(name) has no correct enum values"
        case .undefindedContentBody(let type):
            return "Cannot resolve content body of type \(type)"
        case .invalidPath(let path):
            return "Invalid path: \(path)"
        case .invalidParameter(let parameter):
            return "Can not resolve external reference for parameter \(parameter)"
        }
    }

}
