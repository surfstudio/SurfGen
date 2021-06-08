//
//  BuldGASTTreeFactory.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import Common
import ReferenceExtractor
import GASTBuilder
import CodeGenerator

/// Configures pipeline for code generator
public struct BuildCodeGeneratorPipelineFactory {

    public static func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: FileManager.default
        )
    }

    public static func build(templates: [Template],
                             serviceName: String,
                             needRewriteExistingFiles: Bool = false,
                             logger: Loger? = nil) -> BuildGASTTreeEntryPoint {
        let schemaBuilder = AnySchemaBuilder()
        let parameterBuilder = AnyParametersBuilder(schemaBuilder: schemaBuilder)
        let mediaTypesBuilder = AnyMediaTypesBuilder(schemaBuilder: schemaBuilder)
        let responsesBuilder = AnyResponsesBuilder(mediaTypesBuilder: mediaTypesBuilder)
        let requestBodiesBuilder = AnyRequestBodiesBuilder(mediaTypesBuilder: mediaTypesBuilder)

        let serviceBuilder = AnyServiceBuilder(
            parameterBuilder: parameterBuilder,
            schemaBuilder: schemaBuilder,
            requestBodyBuilder: requestBodiesBuilder,
            responseBuilder: responsesBuilder
        )
        
        let templateFiller = DefaultTemplateFiller()
        let modelExtractor = ModelExtractor()

        return .init(
            refExtractorProvider: self.provider(str:),
            next: .init(
                builder: AnyGASTBuilder(
                    fileProvider: FileManager.default,
                    schemaBuilder: schemaBuilder,
                    parameterBuilder: parameterBuilder,
                    serviceBuilder: serviceBuilder,
                    responsesBuilder: responsesBuilder,
                    requestBodiesBuilder: requestBodiesBuilder),
                next: InitCodeGenerationStage(
                    parserStage: .init(
                        next: SwaggerCorrectorStage(
                            corrector: SwaggerCorrector(logger: logger),
                            next: ServiceGenerationStage(
                                next: FileWriterStage(
                                    needRewriteExistingFiles: needRewriteExistingFiles,
                                    logger: logger
                                ).erase(),
                                templates: templates,
                                serviceName: serviceName,
                                templateFiller: templateFiller,
                                modelExtractor: modelExtractor
                            ).erase()
                        ).erase(),
                        parser: buildParser()
                    )
                ).erase()
            )
        )
    }

    static func buildParser() -> TreeParser {

        let arrayParser = AnyArrayParser()
        let groupParser = AnyGroupParser()

        let mediaTypeParser = AnyMediaTypeParser(arrayParser: arrayParser,
                                                 groupParser: groupParser)
        let requestBodyParser = RequestBodyParser(mediaTypeParser: mediaTypeParser)
        let responsesParser = ResponseBodyParser(mediaTypeParser: mediaTypeParser)

        return .init(parametersParser: .init(array: arrayParser),
                     requestBodyParser: requestBodyParser,
                     responsesParser: responsesParser)
    }
}
