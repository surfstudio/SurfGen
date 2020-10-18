//
//  DeprecatedFinder.swift
//  
//
//  Created by Dmitry Demyanov on 18.10.2020.
//

import Swagger

final class DeprecatedFinder {
    
    /// Removes paths, where all operations are deprecated
    /// - Parameter paths: paths found in API
    /// - Returns: paths without all deprecated operations
    func removeDeprecated(from paths: [Path]) -> [Path] {
        return paths.filter { !$0.operations.allSatisfy { $0.deprecated } }
    }

}
