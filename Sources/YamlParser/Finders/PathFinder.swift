//
//  PathFinder.swift
//  
//
//  Created by Dmitry Demyanov on 17.10.2020.
//

import Swagger

final class PathFinder {
    
    /// Find paths, starting with provided service name
    /// - Parameters:
    ///   - paths: all paths found in API
    ///   - serviceName: to look for
    /// - Returns: filteres paths matching service name
    func findMatchingPaths(from paths: [Path], for rootPath: String) -> [Path] {
        return paths.filter { $0.path.pathToCamelCase().hasPrefix(rootPath.lowercaseFirstLetter()) }
    }

}
