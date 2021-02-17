//
//  ServiceGenerationStage.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import Common
import CodeGenerator

public struct ServiceGenerationStage: PipelineStage {

    private enum ContextKeys {
        static let service = "service"
        static let model = "model"
        static let `enum` = "enum"
    }
    
    private let templateFiller: TemplateFiller
    private let modelExtractor: ModelExtractor

    var next: AnyPipelineStage<[SourceCode]>

    private let templates: [Template]
    private let serviceName: String

    public init(
        next: AnyPipelineStage<[SourceCode]>,
        templates: [Template],
        serviceName: String,
        templateFiller: TemplateFiller,
        modelExtractor: ModelExtractor
    ) {
        self.next = next
        self.templates = templates
        self.serviceName = serviceName
        self.templateFiller = templateFiller
        self.modelExtractor = modelExtractor
    }

    public func run(with input: [[PathModel]]) throws {
        let compact = input.filter { $0.count != 0 }
        
        guard
            compact.count == 1,
            let servicePaths = compact.first
        else {
            throw CommonError(message: "We expect only one service to generate, but got \(compact.count)")
        }

        let serviceGenerationModel = ServiceGenerationModel(name: serviceName, paths: servicePaths)
        
        let schemaModels = modelExtractor.extractModels(from: serviceGenerationModel)
        
        let objectModels = schemaModels.compactMap { $0.containedObject }
        let enumModels = schemaModels.compactMap { $0.containedEnum }
        let typeAliasModels = schemaModels.compactMap { $0.containedTypealias }
        
        // fill templates
        
        let generatedService = try fillTemplates(templates.filter { $0.type == .service },
                                                 with: [ContextKeys.service: serviceGenerationModel],
                                                 name: serviceGenerationModel.name)

        let generatedModels = try objectModels.flatMap {
            return try fillTemplates(templates.filter { $0.type == .model },
                                     with: [ContextKeys.model: $0],
                                     name: $0.name)
        }

        let generatedEnums = try enumModels.flatMap {
            return try fillTemplates(templates.filter { $0.type == .enum },
                                     with: [ContextKeys.enum: $0],
                                     name: $0.name)
        }

        let generatedTypeAliases = try typeAliasModels.flatMap {
            return try fillTemplates(templates.filter { $0.type == .typealias },
                                     with: [ContextKeys.model: $0],
                                     name: $0.name)
        }

        try next.run(with: generatedService + generatedModels + generatedEnums + generatedTypeAliases)
        
    }

    private func fillTemplates(_ templates: [Template], with model: [String: Any], name: String) throws -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath, with: model),
                                      message: "While filling template at \(template.templatePath) with model \(name)")
            return SourceCode(code: sourceCode,
                              fileName: template.buildFileName(for: name),
                              destinationPath: template.destinationPath)
        }
    }
}

private extension Template {
    func buildFileName(for modelName: String) -> String {
        let fileName = modelName + (nameSuffix ?? "")
        let fileNameCase = self.fileNameCase ?? .camelCase
        return fileNameCase.nameTransformation(fileName) + "." + fileExtension
    }
}
