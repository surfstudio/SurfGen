//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import ReferenceExtractor
import GASTBuilder

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
        let serviceBuilder = AnyServiceBuilder(parameterBuilder: parameterBuilder, schemaBuilder: schemaBuilder)
        let mediaTypesBuilder = AnyMediaTypesBuilder(schemaBuilder: schemaBuilder)
        let responsesBuilder = AnyResponsesBuilder(mediaTypesBuilder: mediaTypesBuilder)
        let requestBodiesBuilder = AnyRequestBodiesBuilder(mediaTypesBuilder: mediaTypesBuilder)
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
                next: InitCodeGenerationStage(parserStage: .init()).erase())
        )
    }
}
