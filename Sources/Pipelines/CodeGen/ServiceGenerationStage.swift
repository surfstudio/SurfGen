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
    }
    
    private let templateFiller: TemplateFiller
    private let modelExtractor: ModelExtractor

    var next: AnyPipelineStage<[GeneratedCode]>

    private let templates: [Template]
    private let serviceName: String

    public init(
        next: AnyPipelineStage<[GeneratedCode]>,
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
        
        let enumModels = schemaModels.compactMap { $0.containedEnum }
        
        // fill templates
        let generatedService = try fillServiceTemplates(templates.filter { $0.type == .service },
                                                        with: serviceGenerationModel)

        try next.run(with: generatedService)
        
    }

    private func fillServiceTemplates(_ templates: [Template],
                                      with service: ServiceGenerationModel) throws  -> [GeneratedCode] {
        return try templates.map { template in
            let sourceCode = try wrap(templateFiller.fillTemplate(at: template.templatePath,
                                                             with: [ContextKeys.service: service]),
                                      message: "while filling template at \(template.templatePath) with service \(service.name)")
            return GeneratedCode(code: sourceCode,
                                 fileName: service.name + (template.nameSuffix ?? "") + "." + template.fileExtension,
                                 destinationPath: template.destinationPath)
        }
    }
}
