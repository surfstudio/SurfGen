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
        return try wrap(environment.renderTemplate(string: loadTemplate(at: path), context: context),
                        message: "While filling template at path: \(path)")
    }

    private func loadTemplate(at path: String) throws -> String {
        let templatePath = Path(path)
        return try wrap(templatePath.read(),
                        message: "While loading template at path: \(path)")
    }

    private func buildTemplateExtension() -> Extension {
        let templateExtension = Extension()

        templateExtension.registerFilter("capitalizeFirstLetter") {
            guard let string = $0 as? String else {
                return $0
            }
            return string.capitalizingFirstLetter()
        }

        templateExtension.registerFilter("lowercaseFirstLetter") {
            guard let string = $0 as? String else {
                return $0
            }
            return string.lowercaseFirstLetter()
        }

        templateExtension.registerFilter("snakeCaseToCamelCase") {
            guard let string = $0 as? String else {
                return $0
            }
            return string.snakeCaseToCamelCase()
        }

        return templateExtension
    }
}
