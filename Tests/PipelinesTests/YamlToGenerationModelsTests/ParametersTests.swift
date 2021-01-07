//
//  File.swift
//  
//
//  Created by Александр Кравченков on 19.12.2020.
//

import Foundation
import XCTest
import CodeGenerator
import UtilsForTesting

@testable import Pipelines

/// WARNING!!!
///
/// If you specialize url like `/path/to/method` and then in parameters you will describe parameter which is located in pacth
/// Then your parameter won't be recongnized!!!

/// This test contains cases for cheking that all scenarious which are conected to parsing parameters works
///
/// Cases:
///
/// - Params definition:
///     - Params with primitive type with `in place declaration` will be parsed
///     - Params with ref in schema on enum will be parsed
///     - Params with ref in schema on object will be parsed
///     - Params with ref in schema on alias will be parsed
///     - Params with ref in schema on another file will be parsed
///     - Params with ref in schema on object with another ref will be parsed
///     - Params with ref on cycled objects will parsed
///
///     - Params with schema definition won't be parsed
///     - Parameters with ref on another parameter won't be parsed
///
/// - Service definition:
///     - ref on param will be parsed
final class ParametersTests: XCTestCase {

    // MARK: - Params definition

    /// Params with primitive type with `in place declaration` will be parsed
    func testWithPrimitiveTypeWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: ParametersTests.yamlWithPrimitiveTypeInPlaceWillBeParsed]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[ServiceModel]]()

        factory.resultClosure = { (val: [[ServiceModel]]) throws -> Void in
            result = val
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let params = result[0][0].operations[0].parameters else {
            XCTFail("Can't extract params from \(result)")
            return
        }

        XCTAssertEqual(params.count, 2)

        let firstParam = params.first(where: { $0.name == "id2" })!
        let secondParam = params.first(where: { $0.name == "id3" })!

        XCTAssertEqual(try firstParam.type().primitiveType(), .integer)
        XCTAssertEqual(try secondParam.type().primitiveType(), .string)
    }

    /// Params with ref in schema on enum will be parsed
    func testParamsWithRefInSchemaOnEnumWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: ParametersTests.yamlParamsWithRefInSchemaOnEnumWillBeParsed]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[ServiceModel]]()

        factory.resultClosure = { (val: [[ServiceModel]]) throws -> Void in
            result = val
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let params = result[0][0].operations[0].parameters else {
            XCTFail("Can't extract params from \(result)")
            return
        }

        XCTAssertEqual(params.count, 1)

        // не видит параметр
        let firstParam = params.first(where: { $0.name == "id" })
        let paramType = try firstParam?.type().notPrimitiveType()

        guard
            let param = paramType,
            case SchemaType.enum = param
        else {
            XCTFail("Type \(paramType.debugDescription) is not enum")
            return
        }
    }

    /// Params with ref in schema on object will be parsed
    func testParamsWithRefInSchemaOnObjectWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: ParametersTests.yamlParamsWithRefInSchemaOnObjectWillBeParsed]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[ServiceModel]]()

        factory.resultClosure = { (val: [[ServiceModel]]) throws -> Void in
            result = val
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let params = result[0][0].operations[0].parameters else {
            XCTFail("Can't extract params from \(result)")
            return
        }

        XCTAssertEqual(params.count, 1)

        // не видит параметр
        let firstParam = params.first(where: { $0.name == "id" })
        let paramType = try firstParam?.type().notPrimitiveType()

        guard
            let param = paramType,
            case SchemaType.object = param
        else {
            XCTFail("Type \(paramType.debugDescription) is not enum")
            return
        }
    }

    /// Params with ref in schema on alias will be parsed
    func testParamsWithRefInSchemaOnAliasWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: ParametersTests.yamlParamsWithRefInSchemaOnAliasWillBeParsed]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[ServiceModel]]()

        factory.resultClosure = { (val: [[ServiceModel]]) throws -> Void in
            result = val
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let params = result[0][0].operations[0].parameters else {
            XCTFail("Can't extract params from \(result)")
            return
        }

        XCTAssertEqual(params.count, 1)

        let firstParam = params.first(where: { $0.name == "id" })
        let paramType = try firstParam?.type().notPrimitiveType()

        guard
            let param = paramType,
            case SchemaType.alias = param
        else {
            XCTFail("Type \(paramType.debugDescription) is not enum")
            return
        }
    }

    /// Params with ref in schema on another file will be parsed
    func testParamsWithRefInSchemaOnAnotherFileWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ParametersTests.yamlParamsWithRefInSchemaOnAnotherFileWillBeParsed,
            pathToModels: ParametersTests.yamlSeparatedModels
        ]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[ServiceModel]]()

        factory.resultClosure = { (val: [[ServiceModel]]) throws -> Void in
            result = val.filter { $0.count != 0 }
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let params = result[0][0].operations[0].parameters else {
            XCTFail("Can't extract params from \(result)")
            return
        }

        XCTAssertEqual(params.count, 1)

        let firstParam = params.first(where: { $0.name == "id" })
        let paramType = try firstParam?.type().notPrimitiveType()

        guard
            let param = paramType,
            case SchemaType.alias = param
        else {
            XCTFail("Type \(paramType.debugDescription) is not enum")
            return
        }
    }

    /// Params with ref on cycled objects will parsed
    func testParamsWithRefOnCycledObjectsWillParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ParametersTests.yamlParamsWithRefOnCycledObjectsWillParsed,
            pathToModels: ParametersTests.yamlSeparatedModels
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act-Assert

        XCTAssertThrowsError(try pipeline.run(with: URL(string: pathToRoot)!)) { (err) in
            print(err.localizedDescription)
        }
    }

    // MARK: - Service definition

    /// Params with ref on cycled objects will parsed
    func testRefOnParamWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathToModels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: ParametersTests.yamlRefOnParamWillBeParsed,
            pathToModels: ParametersTests.yamlSeparatedModels
        ]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[ServiceModel]]()

        factory.resultClosure = { (val: [[ServiceModel]]) throws -> Void in
            result = val.filter { $0.count != 0 }
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard let params = result[0][0].operations[0].parameters else {
            XCTFail("Can't extract params from \(result)")
            return
        }

        XCTAssertEqual(params.count, 1)

        let firstParam = params.first(where: { $0.name == "id" })
        let paramType = try firstParam?.refType()

        XCTAssertNotNil(paramType)
    }

}
