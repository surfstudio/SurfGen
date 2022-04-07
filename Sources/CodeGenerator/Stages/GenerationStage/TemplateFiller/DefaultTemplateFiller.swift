//
//  DefaultTemplateFiller.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Common
import Foundation
import PathKit
import Stencil

public class DefaultTemplateFiller: TemplateFiller {
    
    public init() {}

    public func fillTemplate(at path: String, with context: [String : Any]) throws -> String {
        var environment = Environment()
        environment.extensions.append(buildTemplateExtension())
        let template = try loadTemplate(at: path)
        do {
            return try environment.renderTemplate(string: template, context: context)
        } catch {
            // There is no implemented `localizedDescription` in Stenicl's TemplateSyntaxError so we have to get the message ourselves
            guard let templateError = error as? TemplateSyntaxError else {
                throw CommonError(message: "Unknown error in template")
            }
            throw CommonError(message: templateError.description)
        }
    }

    func buildTemplateExtension() -> Extension {
        let templateExtension = Extension()

        templateExtension.registerStringFilter("capitalizeFirstLetter") {
            $0.capitalizingFirstLetter()
        }

        templateExtension.registerStringFilter("lowercaseFirstLetter") {
            $0.lowercaseFirstLetter()
        }

        templateExtension.registerStringFilter("snakeCaseToCamelCase") {
            $0.snakeCaseToCamelCase()
        }

        templateExtension.registerStringFilter("camelCaseToSnakeCase") {
            $0.camelCaseToSnakeCase()
        }

        templateExtension.registerStringFilter("camelCaseToCaps") {
            $0.camelCaseToSnakeCase().uppercased()
        }

        templateExtension.registerStringFilter("trim") {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        templateExtension.registerStringFilter("splitLines") {
            $0.split(separator: "\n")
        }

        templateExtension.registerStringFilter("upperCaseToCamelCase") {
            $0.upperCaseToCamelCase()
        }

        templateExtension.registerStringFilter("upperCaseToCamelCaseOrSelf") {
            $0.upperCaseToCamelCaseOrSelf()
        }
        
        templateExtension.registerStringFilter("sanitizeUrlPath") {
            $0.sanitizeUrlPath()
        }
        
        return templateExtension
    }
    
    
    private func loadTemplate(at path: String) throws -> String {
        let templatePath = Path(path)
        return try wrap(templatePath.read(),
                        message: "While loading template at path: \(path)")
    }
}
