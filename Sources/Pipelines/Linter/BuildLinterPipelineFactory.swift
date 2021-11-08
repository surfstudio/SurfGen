//
//  BuildLinterPipelineFactory.swift
//
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import ReferenceExtractor
import GASTBuilder
import CodeGenerator
import Common
import ASTTree

/// Configures pipeline for liniting
public struct BuildLinterPipelineFactory {

    public static func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: FileManager.default
        )
    }

    public static func build(filesToIgnore: Set<String>, astNodesToExclude: Set<String>, log: Loger) -> OpenAPILinter {
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

        return .init(
            filesToIgnore: filesToIgnore,
            log: log,
            next: DirRefExtractor(
                refExtractorProvider: provider,
                next: OpenAPIASTBuilderStage(
                    fileProvider: FileManager.default,
                    next: OpenAPIASTExcludingStage(
                        excluder: ASTNodeExcluder(logger: log),
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
                                        corrector: SwaggerCorrector(logger: log)
                                    ).erase(),
                                    parser: buildParser(logger: log)
                                )
                            ).erase()
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
