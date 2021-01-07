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

/// Configures pipeline for liniting
public struct BuildLinterPipelineFactory {

    public static func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: FileManager.default
        )
    }

    public static func build(filesToIgnore: Set<String>, log: Logger) -> OpenAPILinter {
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
                            next: ServiceGenerationStage(templatePathes: []).erase(),
                            parser: buildParser()
                        )
                    ).erase()
                ).erase()
            ).erase()
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
