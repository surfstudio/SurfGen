//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import XCTest
import CodeGenerator
import GASTTree
import UtilsForTesting

/// Cases:
///
/// - Array
///     - Can be parsed in components
///     - Can be parsed in response declaration
///     - Can be parsed array with refs on alias, enum, object
final class SchemaObjectUseCasesTests: XCTestCase {

    func testArrayCanBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: SchemaObjectUseCasesYamls.arrayCanBeParsed]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    func testArrayInResponseDeclrationCanBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: SchemaObjectUseCasesYamls.arrayInResponseDeclrationCanBeParsed]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    func testArrayInResponseWithObjAliasEnumWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let pathTomodels = "/path/to/models.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: SchemaObjectUseCasesYamls.arrayInResponseWithRefs,
            pathTomodels: SchemaObjectUseCasesYamls.components
        ]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: URL(string: pathToRoot)!))
    }

    func testIntEnumWillBeInterpretedAsEnumAndNotAsTypealias() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [
            pathToRoot: SchemaObjectUseCasesYamls.intEnum,
        ]

        var result = [DependencyWithTree]()

        let stub = InitCodeGenerationStageStub(closure: { result = $0 })

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider, initCodeGeneratorStageStub: stub.erase()).build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        let value = result[0].tree.schemas[0]

        guard case SchemaObjectNode.Possibility.enum(_) = value.next else {
            XCTFail("Expected type is enum. But got \(value.next)")
            return
        }

    }
}
