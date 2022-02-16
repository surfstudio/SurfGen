//
//  TemplateFiller.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Foundation

public protocol TemplateFiller {
    /// Load template at given path and fill it with provided context
    /// Returns filled template  text
    func fillTemplate(
        at path: String,
        with context: [String: Any],
        specificationRootPath: String
    ) throws -> String
}
