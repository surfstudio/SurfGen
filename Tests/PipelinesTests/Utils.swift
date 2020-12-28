//
//  Utils.swift
//  
//
//  Created by Александр Кравченков on 19.12.2020.
//

import Foundation
import Common
import ReferenceExtractor
import GASTBuilder
import GASTTree
import Pipelines
import CodeGenerator

class FileProviderStub: FileProvider {

    var isReadableFile: Bool = false

    var files: [String: Data] = [:]

    var readCount = 0

    func isReadableFile(at path: String) -> Bool {
        return isReadableFile
    }

    func readFile(at path: String) throws -> Data? {
        readCount += 1
        return files[path]
    }
}


public struct StubGASTTreeFactory {

    var fileProvider: FileProvider
    var resultClosure: (([[ServiceModel]]) throws -> Void)?

    public func provider(str: URL) throws -> ReferenceExtractor {
        return try .init(
            pathToSpec: str,
            fileProvider: fileProvider
        )
    }

    public func build(enableDisclarationChecking: Bool = false) -> BuildGASTTreeEntryPoint {
        let schemaBuilder = AnySchemaBuilder()
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

        return .init(
            refExtractorProvider: self.provider(str:),
            next: .init(
                builder: AnyGASTBuilder(
                    fileProvider: fileProvider,
                    schemaBuilder: schemaBuilder,
                    parameterBuilder: parameterBuilder,
                    serviceBuilder: serviceBuilder,
                    responsesBuilder: responsesBuilder,
                    requestBodiesBuilder: requestBodiesBuilder),
                next: InitCodeGenerationStage(parserStage: .init(next: resultClosure, parser: parser)).erase())
        )
    }

    func buildParser(enableDisclarationChecking: Bool = false) -> TreeParser {

        let mediaTypeParser: MediaTypeParser = enableDisclarationChecking ?
            AnyMediaTypeParser() :
            AnyMediaTypeParserStub()

        let requestBodyParser = RequestBodyParser(mediaTypeParser: mediaTypeParser)
        let responsesParser = ResponseBodyParser(mediaTypeParser: mediaTypeParser)

        return .init(parametersParser: .init(),
                     requestBodyParser: requestBodyParser,
                     responsesParser: responsesParser)
    }
}

extension Reference where DataType == ParameterModel {
    var name: String {
        switch self {
        case .reference(let val):
            return val.name
        case .notReference(let val):
            return val.name
        }
    }

    func type() throws -> ParameterModel.PossibleType {
        switch self {
        case .notReference(let val):
            return val.type
        case .reference:
            throw CustomError.init(message: "It's reference not a primitive")
        }
    }

    func refType() throws -> ParameterModel.PossibleType {
        switch self {
        case .notReference:
            throw CustomError.init(message: "It's primitive not a reference")
        case .reference(let val):
            return val.type
        }
    }
}

extension ParameterModel.PossibleType {
    func primitiveType() throws -> PrimitiveType {
        switch self {
        case .primitive(let val):
            return val
        case .reference(let ref):
            throw CustomError(message: "The parameter's type is reference \(ref)")
        }
    }

    func notPrimitiveType() throws -> SchemaType {
        switch self {
        case .primitive(let val):
            throw CustomError(message: "The parameter's type is primitive: \(val)")
        case .reference(let val):
            return val
        }
    }
}
