//
//  DeprecatedFinder.swift
//  
//
//  Created by Dmitry Demyanov on 18.10.2020.
//

import Swagger

final class DeprecatedFinder {
    
    /// Removes deprecated operations
    /// - Parameter paths: all operations found in API
    /// - Returns: operations without deprecated ones
    func removeDeprecated(from operations: [Operation]) -> [Operation] {
        return operations.filter { !$0.deprecated }
    }

}
