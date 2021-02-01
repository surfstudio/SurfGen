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
        let generatedService = try fillServiceTemplates(templates.filter { $0.type == .service },
                                                        with: serviceGenerationModel)
        let generatedModels = try objectModels.flatMap {
            return try fillObjectTemplates(templates.filter { $0.type == .model },
                                           with: $0)
        }

        let generatedEnums = try enumModels.flatMap {
            return try fillEnumTemplates(templates.filter { $0.type == .enum },
                                         with: $0)
        }

        let generatedTypeAliases = try typeAliasModels.flatMap {
            return try fillTypealiasTemplates(templates.filter { $0.type == .typealias },
                                              with: $0)
        }

        try next.run(with: generatedService + generatedModels + generatedEnums + generatedTypeAliases)
        
    }

    private func fillServiceTemplates(_ templates: [Template],
                                      with model: ServiceGenerationModel) throws  -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                                  with: [ContextKeys.service: model]),
                                      message: "while filling template at \(template.templatePath) with service \(model.name)")
            return SourceCode(code: sourceCode,
                                 fileName: model.name + (template.nameSuffix ?? "") + "." + template.fileExtension,
                                 destinationPath: template.destinationPath)
        }
    }

    private func fillObjectTemplates(_ templates: [Template],
                                     with model: SchemaObjectModel) throws  -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                                  with: [ContextKeys.model: model]),
                                      message: "while filling template at \(template.templatePath) with model \(model.name)")
            return SourceCode(code: sourceCode,
                              fileName: template.buildFileName(for: model.name),
                              destinationPath: template.destinationPath)
        }
    }

    private func fillEnumTemplates(_ templates: [Template],
                                   with model: SchemaEnumModel) throws  -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                                  with: [ContextKeys.enum: model]),
                                      message: "while filling template at \(template.templatePath) with model \(model.name)")
            return SourceCode(code: sourceCode,
                                 fileName: template.buildFileName(for: model.name),
                                 destinationPath: template.destinationPath)
        }
    }

    private func fillTypealiasTemplates(_ templates: [Template],
                                        with model: PrimitiveTypeAliasModel) throws  -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                                  with: [ContextKeys.model: model]),
                                      message: "while filling template at \(template.templatePath) with model \(model.name)")
            return SourceCode(code: sourceCode,
                              fileName: template.buildFileName(for: model.name),
                              destinationPath: template.destinationPath)
        }
    }
}

private extension Template {
    func buildFileName(for modelName: String) -> String {
        return modelName + (nameSuffix ?? "") + "." + fileExtension
    }
}
