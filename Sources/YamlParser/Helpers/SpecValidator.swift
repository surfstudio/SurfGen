//
//  SpecValidator.swift
//  
//
//  Created by Dmitry Demyanov on 29.11.2020.
//

import Swagger

class SpecValidator {

    /// Checks if path does not include query parameters
    /// https://swagger.io/docs/specification/paths-and-operations/#query-string-in-paths
    func isPathValid(_ path: String) -> Bool {
        return !path.contains("?")
    }

    /// Detect if parameters contain external reference
    /// Swagger parser cannot handle external references
    func findInvalidParameter(in parameters: [PossibleReference<Parameter>]) -> String? {
        for parameter in parameters {
            guard parameter.possibleValue != nil else {
                return parameter.name
            }
        }
        return nil
    }

}
