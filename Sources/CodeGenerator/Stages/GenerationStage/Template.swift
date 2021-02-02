//
//  Template.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Foundation

/// This model keeps information about template and file generated with this template
public struct Template: Decodable {
    
    /// Describes which file is generated with this template and therefore what context is used to fill this template
    public enum TemplateType: String, Decodable {
        case service
        case model
        case `enum`
        case `typealias`
    }

    public let type: TemplateType

    /// All files generated with this template will have this suffix after passed name
    /// Examples: NetworkService, Repository, Urls, Entity
    public let nameSuffix: String?

    /// All files generated with this template will have this extension
    /// Examples: swift, dart, kt
    public let fileExtension: String
    
    /// Template file location
    /// Example:  Path/To/Project/SurfGenTemplates/example.txt
    public let templatePath: String

    /// Where to place file generated with this template
    /// Example: Path/To/Project/Models
    public let destinationPath: String

    public init(type: Template.TemplateType,
                nameSuffix: String?,
                fileExtension: String,
                templatePath: String,
                destinationPath: String) {
        self.type = type
        self.nameSuffix = nameSuffix
        self.fileExtension = fileExtension
        self.templatePath = templatePath
        self.destinationPath = destinationPath
    }
}
