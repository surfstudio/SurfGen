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

    public enum FileNameCase: String, Decodable {
        case camelCase
        case snakeCase

        public func apply(for name: String) -> String {
            switch self {
            case .camelCase:
                return name
            case .snakeCase:
                return name.camelCaseToSnakeCase()
            }
        }
    }

    public let type: TemplateType

    /// All files generated with this template will have this suffix after passed name
    /// Examples: NetworkService, Repository, Urls, Entity
    public let nameSuffix: String?

    /// All files generated with this template will have this extension
    /// Examples: swift, dart, kt
    public let fileExtension: String

    /// String case for files, generated with this template
    /// Examples: TestModelName.txt, test_model_name.txt
    public let fileNameCase: FileNameCase?
    
    /// Template file location
    /// Example:  Path/To/Project/SurfGenTemplates/example.txt
    public let templatePath: String

    /// Where to place file generated with this template
    /// Example: Path/To/Project/Models
    public let destinationPath: String

    public init(type: Template.TemplateType,
                nameSuffix: String?,
                fileExtension: String,
                fileNameCase: FileNameCase? = .camelCase,
                templatePath: String,
                destinationPath: String) {
        self.type = type
        self.nameSuffix = nameSuffix
        self.fileExtension = fileExtension
        self.fileNameCase = fileNameCase
        self.templatePath = templatePath
        self.destinationPath = destinationPath
    }
}
