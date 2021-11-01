//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import Common
import ReferenceExtractor
import GASTBuilder
import GASTTree
import Pipelines
import CodeGenerator


public struct StubGASTTreeFactory {

    public var useNewNullableDeterminationStrategy: Bool = false
    public var fileProvider: FileProvider
    public var resultClosure: (([[PathModel]]) throws -> Void)?
    public var initCodeGeneratorStageStub: AnyPipelineStage<[DependencyWithTree]>?

    public init(fileProvider: FileProvider,
                initCodeGeneratorStageStub: AnyPipelineStage<[DependencyWithTree]>? = nil,
                resultClosure: (([[PathModel]]) throws -> Void)? = nil) {
        self.fileProvider = fileProvider
        self.resultClosure = resultClosure
        self.initCodeGeneratorStageStub = initCodeGeneratorStageStub
    }

    public func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: fileProvider
        )
    }

    public func build(enableDisclarationChecking: Bool = false) -> BuildGASTTreeEntryPoint {
        let schemaBuilder = AnySchemaBuilder(useNewNullableDeterminationStrategy: self.useNewNullableDeterminationStrategy)
        let parameterBuilder = AnyParametersBuilder(schemaBuilder: schemaBuilder)
        let mediaTypesBuilder = AnyMediaTypesBuilder(schemaBuilder: schemaBuilder,
                                                     enableDisclarationChecking: enableDisclarationChecking)
        let responsesBuilder = AnyResponsesBuilder(mediaTypesBuilder: mediaTypesBuilder)
        let requestBodiesBuilder = AnyRequestBodiesBuilder(mediaTypesBuilder: mediaTypesBuilder)

        let serviceBuilder = AnyServiceBuilder(
            parameterBuilder: parameterBuilder,
            schemaBuilder: schemaBuilder,
            requestBodyBuilder: requestBodiesBuilder,
            responseBuilder: responsesBuilder
        )

        let parser = self.buildParser(enableDisclarationChecking: enableDisclarationChecking)

        var initStage: AnyPipelineStage<[DependencyWithTree]> = InitCodeGenerationStage(
            parserStage: .init(
                next: TreeParserStageResultStub(next: resultClosure).erase(),
                parser: parser)
        ).erase()

        if let stage = self.initCodeGeneratorStageStub {
            initStage = stage.erase()
        }

        return .init(
            refExtractorProvider: self.provider(str:),
            next: OpenAPIASTBuilderStage(
                fileProvider: self.fileProvider,
                next: BuildGastTreeParseDependenciesSatage(
                    builder: AnyGASTBuilder(
                        fileProvider: fileProvider,
                        schemaBuilder: schemaBuilder,
                        parameterBuilder: parameterBuilder,
                        serviceBuilder: serviceBuilder,
                        responsesBuilder: responsesBuilder,
                        requestBodiesBuilder: requestBodiesBuilder),
                    next: initStage
                ).erase()
            ).erase()
        )
    }

    func buildParser(enableDisclarationChecking: Bool = false) -> TreeParser {

        let arrayParser = AnyArrayParser()
        let groupParser = AnyGroupParser()

        let mediaParser = AnyMediaTypeParser(arrayParser: arrayParser, groupParser: groupParser)
        let mediaParserStub = AnyMediaTypeParserStub(arrayParser: arrayParser, groupParser: groupParser)

        let mediaTypeParser: MediaTypeParser = enableDisclarationChecking ?
            mediaParser:
            mediaParserStub

        let requestBodyParser = RequestBodyParser(mediaTypeParser: mediaTypeParser)
        let responsesParser = ResponseBodyParser(mediaTypeParser: mediaTypeParser)

        return .init(parametersParser: .init(array: arrayParser),
                     requestBodyParser: requestBodyParser,
                     responsesParser: responsesParser)
    }
}

public struct TreeParserStageResultStub: PipelineStage {

    public var next: (([[PathModel]]) throws -> Void)?

    public init(next: (([[PathModel]]) throws -> Void)?) {
        self.next = next
    }

    public func run(with input: [[PathModel]]) throws {
        try self.next?(input)
    }
}

public struct InitCodeGenerationStageStub: PipelineStage {

    public var closure: ([DependencyWithTree]) -> Void

    public init(closure: @escaping ([DependencyWithTree]) -> Void) {
        self.closure = closure
    }

    public func run(with input: [DependencyWithTree]) throws {
        self.closure(input)
    }
}
