//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import XCTest

/// Cases:
///
/// - Array
///     - Can be parsed
final class SchemaObjectUseCasesTests: XCTestCase {

    func testArrayCanBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: SchemaObjectUseCasesYamls.arrayCanBeParsed]

        let pipeline = StubGASTTreeFactory(fileProvider: fileProvider).build()

        // Act - Assert

        XCTAssertNoThrow(try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!)))
    }
}
