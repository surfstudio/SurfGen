//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import XCTest
import UtilsForTesting

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
///     - RequestBody without content won't be parsed
///     - RequestBody with declaration in schema won't be parsed
///
/// - Response
///     - Response with ref will be parsed
///     - Ref on Responses will be parsed
///     - Response with several media types will be parsed
///     - Response with `default` content will be parsed
///     - Response without content will be parsed
///     - Response with declaration in schema won't be parsed
///     - Separated Response with schema declaration won't be parsed
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

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
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

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
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

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
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

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
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

        XCTAssertThrowsError(try pipeline.run(with: URL(string: pathToRoot)!))
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

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
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

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
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

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    /// RequestBody without content won't be parsed
    func testRequestBodyWithoutContentWontBeParsed() {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.requestBodyWithoutContentWontBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build(enableDisclarationChecking: true)

        // Act - Assert

        XCTAssertThrowsError(try pipeline.run(with: URL(string: pathToRoot)!))
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

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build(enableDisclarationChecking: true)

        // Act - Assert

        XCTAssertThrowsError(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    // MARK: - Responses

    /// Response with ref will be parsed
    func testResponseWithRefWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseWithRefWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    /// Ref on Responses will be parsed
    func testResponseWithRefOnResponseWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseWithRefOnResponseWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    /// Response with several media types will be parsed
    func testResponseWithSeveralMediaTypesWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseWithSeveralMediaTypesWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    /// Response with `default` content will be parsed
    func testResponseWithDefaultContentWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseWithDefaultContentWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    /// Response without content will be parsed
    func testResponseWithoutContentWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseWithoutContentWillBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    /// Response with declaration in schema won't be parsed
    func testResponseWithDeclarationInSchemaWontBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseWithDeclarationInSchemaWontBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build(enableDisclarationChecking: true)

        // Act - Assert

        XCTAssertThrowsError(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    /// Separated Response with schema declaration won't be parsed
    func testResponseSeparatedResponseWithSchemaDeclarationWontBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ServiceUseCasesTestsYamls.responseSeparatedResponseWithSchemaDeclarationWontBeParsed,
            pathToModels: ServiceUseCasesTestsYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build(enableDisclarationChecking: true)

        // Act - Assert

        XCTAssertThrowsError(try pipeline.run(with: URL(string: pathToRoot)!))
    }
}
