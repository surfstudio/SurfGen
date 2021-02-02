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

        templateExtension.registerStringFilter("capitalizeFirstLetter") {
            $0.capitalizingFirstLetter()
        }

        templateExtension.registerStringFilter("lowercaseFirstLetter") {
            $0.lowercaseFirstLetter()
        }

        templateExtension.registerStringFilter("snakeCaseToCamelCase") {
            $0.snakeCaseToCamelCase()
        }

        templateExtension.registerStringFilter("camelCaseToCaps") {
            $0.camelCaseToCaps()
        }

        templateExtension.registerStringFilter("trim") {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        templateExtension.registerStringFilter("splitLines") {
            $0.split(separator: "\n")
        }

        return templateExtension
    }
}

private extension Extension {

    func registerStringFilter(_ name: String, stringFilter: @escaping (String) -> Any) {
        registerFilter(name) {
            guard let stringValue = $0 as? String else {
                return $0
            }
            return stringFilter(stringValue)
        }
    }
}
