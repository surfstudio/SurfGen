//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import XCTest

/// Cases:
///
/// - Parameters
///     - No Parameters will be parsed
///     - In place Parameters will be parsed
///     - Parameters with ref in type will be parsed
///     - Parameters as ref will be parsed
///     - Parameters with declaration in type won't be parsed
///     
/// - Request
///     - RequestBody with ref will be parsed
///     - Ref on RequestBody will be parsed
///     - RequestBody with several media types will be parsed
///     - RequestBody with declaration in schema won't be parsed
///
/// - Response
///     - Response with ref will be parsed
///     - Ref on Responses will be parsed
///     - Response with several media types will be parsed
///     - Response with `default` content will be parsed
///     - Response with declaration in schema won't be parsed
///     - Response wuthout content won't be parsed
final class ServiceUseCasesTests: XCTestCase {

    // MARK: - Parameters

    /// No Parameters will be parsed
    func testParametersEmptyParamsWillBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: ServiceUseCasesTestsYamls.parametersEmptyParamsWillBeParsed]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()
        
        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    /// In place Parameters will be parsed
    func testInPlaceParametersWillBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: ServiceUseCasesTestsYamls.inPlaceParametersWillBeParsed]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    /// Parameters with ref in type will be parsed
    func testParametersWithRefInTypeWillBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.parametersWithRefInTypeWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    /// Parameters as ref will be parsed
    func testParametersAsRefWillBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.parametersAsRefWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    /// Parameters with declaration in type won't be parsed
    func testParametersWithDeclarationInTypeWontBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.parametersWithDeclarationInTypeWontBeParsed,
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertThrowsError(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    // MARK: - Requests

    ///     - RequestBody with declaration in schema won't be parsed

    /// RequestBody with ref will be parsed
    func testRequestWithRefWillBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.requestWithRefWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    /// Ref on RequestBody will be parsed
    func testRequestRefOnRequestBodyWillBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.requestRefOnRequestBodyWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    /// RequestBody with several media types will be parsed
    func testRequestWithSeveralMediaTypesWillBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.requestWithSeveralMediaTypesWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    /// RequestBody with declaration in schema won't be parsed
    func testRequestBodyWithDeclarationInSchemaWontBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.requestBodyWithDeclarationInSchemaWontBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertThrowsError(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }

    // MARK: - Responses
}
