//
//  GASTBuilerError.swift
//  AEXML
//
//  Created by Mikhail Monakov on 12/03/2020.
//

import Foundation
import Swagger

enum GASTBuilerError: Error {
    case undefinedTypeForField(String)
    case nonObjectNodeFound(String)
}

extension GASTBuilerError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .undefinedTypeForField(let type):
            return "Can not resolve type for provided SchemaType which is type of \(type)"
        case .nonObjectNodeFound(let name):
            return "Can not find object in provided Component object with name: \(name)"
        }
    }

}
