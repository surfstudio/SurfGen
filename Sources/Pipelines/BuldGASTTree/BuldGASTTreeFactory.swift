//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import ReferenceExtractor
import GASTBuilder
import CodeGenerator

public struct BuldGASTTreeFactory {

    public static func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: FileManager.default
        )
    }

    public static func build() -> BuildGASTTreeEntryPoint {
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
                        next: ServiceGenerationStage(templatePathes: []).erase(),
                        parser: buildParser()
                    )
                ).erase()
            )
        )
    }

    static func buildParser() -> TreeParser {

        let mediaTypeParser = AnyMediaTypeParser()
        let requestBodyParser = RequestBodyParser(mediaTypeParser: mediaTypeParser)
        let responsesParser = ResponseBodyParser(mediaTypeParser: mediaTypeParser)

        return .init(parametersParser: .init(),
                     requestBodyParser: requestBodyParser,
                     responsesParser: responsesParser)
    }
}
