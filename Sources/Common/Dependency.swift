//
//  Dependency.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation

public struct Dependency {
    public let pathToCurrentFile: String
    /// Key is $ref value
    /// Value is full path to file which is referenced by key
    public var dependecies: [String: String]

    public init(pathToCurrentFile: String, dependecies: [String: String]) {
        self.pathToCurrentFile = pathToCurrentFile
        self.dependecies = dependecies
    }
}
