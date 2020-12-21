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

    public func build() -> BuildGASTTreeEntryPoint {
        let schemaBuilder = AnySchemaBuilder()
        let parameterBuilder = AnyParametersBuilder(schemaBuilder: schemaBuilder)
        let serviceBuilder = AnyServiceBuilder(parameterBuilder: parameterBuilder)
        return .init(
            refExtractorProvider: self.provider(str:),
            next: .init(
                builder: AnyGASTBuilder(
                    fileProvider: fileProvider,
                    schemaBuilder: schemaBuilder,
                    parameterBuilder: parameterBuilder,
                    serviceBuilder: serviceBuilder),
                next: .init(parserStage: .init(next: resultClosure)))
        )
    }
}

extension Reference where RefType == ParameterModel, NotRefType == ParameterModel {
    var name: String {
        switch self {
        case .reference(let val):
            return val.name
        case .notReference(let val):
            return val.name
        }
    }

    var type: ParameterModel.PossibleType {
        switch self {
        case .reference(let val):
            return val.type
        case .notReference(let val):
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
