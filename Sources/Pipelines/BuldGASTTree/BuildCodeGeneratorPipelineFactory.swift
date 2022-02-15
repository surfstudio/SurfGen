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
import Operations
import ASTTree

/// Configures pipeline for code generator
public struct BuildCodeGeneratorPipelineFactory {

    public static func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: FileManager.default
        )
    }

    public static func build(templates: [Template],
                             specificationRootPath: String,
                             astNodesToExclude: Set<String>,
                             serviceName: String,
                             needRewriteExistingFiles: Bool = false,
                             useNewNullableDefinitionStartegy: Bool,
                             prefixCutter: PrefixCutter? = nil,
                             logger: Loger? = nil) -> BuildGASTTreeEntryPoint {

        let schemaBuilder = AnySchemaBuilder(useNewNullableDeterminationStrategy: useNewNullableDefinitionStartegy)

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
            next: OpenAPIASTBuilderStage(
                fileProvider: FileManager.default,
                next: OpenAPIASTExcludingStage(
                    excluder: ASTNodeExcluder(logger: logger),
                    excludeList: astNodesToExclude,
                    next: BuildGastTreeParseDependenciesSatage(
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
                                        next: SourceCodeFolderDistributorStage(
                                            next: FileWriterStage(
                                                needRewriteExistingFiles: needRewriteExistingFiles,
                                                logger: logger
                                            ).erase(),
                                            specificationRootPath: specificationRootPath
                                        ).erase(),
                                        templates: templates,
                                        serviceName: serviceName,
                                        templateFiller: templateFiller,
                                        modelExtractor: modelExtractor,
                                        prefixCutter: prefixCutter
                                    ).erase()
                                ).erase(),
                                parser: buildParser(logger: logger)
                            )
                        ).erase()
                    ).erase()
                ).erase()
            ).erase()
        )
    }

    static func buildParser(logger: Loger?) -> TreeParser {

        let resolver = Resolver(logger: logger)

        let arrayParser = AnyArrayParser(resolver: resolver)
        let groupParser = AnyGroupParser(resolver: resolver)

        let mediaTypeParser = AnyMediaTypeParser(arrayParser: arrayParser,
                                                 groupParser: groupParser,
                                                 resolver: resolver)
        let parametersParser = ParametersTreeParser(array: arrayParser,
                                                    resolver: resolver)
        let requestBodyParser = RequestBodyParser(mediaTypeParser: mediaTypeParser,
                                                  resolver: resolver)
        let responsesParser = ResponseBodyParser(mediaTypeParser: mediaTypeParser,
                                                 resolver: resolver)
        

        return .init(parametersParser: parametersParser,
                     requestBodyParser: requestBodyParser,
                     responsesParser: responsesParser)
    }
}
