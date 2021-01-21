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

        try next.run(with: generatedService + generatedModels + generatedEnums)
        
    }

    private func fillServiceTemplates(_ templates: [Template],
                                      with service: ServiceGenerationModel) throws  -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                                  with: [ContextKeys.service: service]),
                                      message: "while filling template at \(template.templatePath) with service \(service.name)")
            return SourceCode(code: sourceCode,
                                 fileName: service.name + (template.nameSuffix ?? "") + "." + template.fileExtension,
                                 destinationPath: template.destinationPath)
        }
    }

    private func fillObjectTemplates(_ templates: [Template],
                                     with object: SchemaObjectModel) throws  -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                                  with: [ContextKeys.model: object]),
                                      message: "while filling template at \(template.templatePath) with model \(object.name)")
            return SourceCode(code: sourceCode,
                                 fileName: object.name + (template.nameSuffix ?? "") + "." + template.fileExtension,
                                 destinationPath: template.destinationPath)
        }
    }

    private func fillEnumTemplates(_ templates: [Template],
                                     with enumModel: SchemaEnumModel) throws  -> [SourceCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                                  with: [ContextKeys.enum: enumModel]),
                                      message: "while filling template at \(template.templatePath) with model \(enumModel.name)")
            return SourceCode(code: sourceCode,
                                 fileName: enumModel.name + (template.nameSuffix ?? "") + "." + template.fileExtension,
                                 destinationPath: template.destinationPath)
        }
    }
}
