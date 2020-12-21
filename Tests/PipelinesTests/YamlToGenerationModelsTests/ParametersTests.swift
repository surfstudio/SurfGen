//
//  File.swift
//  
//
//  Created by Александр Кравченков on 19.12.2020.
//

import Foundation
import XCTest
import CodeGenerator

@testable import Pipelines

/// This test contains cases for cheking that all scenarious which are conected to parsing parameters works
///
/// Cases:
///
/// - Params definition:
///     - Params with primitive type with `in place declaration` will be parsed
///     - Params with ref on enum will be parsed
///     - Params with ref on object will be parsed
///     - Params with ref on alias will be parsed
///     - Params with ref on another file will be parsed
///     - Params with ref on ojbect with another ref will be parsed
///
///     - Params with schema definition won't be parsed
///     - Parameters with ref on another parameter won't be parsed
///
/// - Service definition:
///     - ref on param will be parsed
///     - param declared in-place (in operation) will be parsed
final class ParametersTests: XCTestCase {

    // MARK: - Params definition

    /// Params with primitive type with `in place declaration` will be parsed
    func testWithPrimitiveTypeWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: ParametersTests.withPrimitiveTypeInPlaceWillBeParsed]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[ServiceModel]]()

        factory.resultClosure = { (val: [[ServiceModel]]) throws -> Void in
            result = val
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: .init(pathToSpec: URL(string: pathToRoot)!))

        // Assert

        guard let params = result[0][0].operations[0].parameters else {
            XCTFail("Can't extract params from \(result)")
            return
        }

        XCTAssertEqual(params.count, 2)

        let firstParam = params.first(where: { $0.name == "id2" })!
        let secondParam = params.first(where: { $0.name == "id3" })!

        XCTAssertEqual(try firstParam.type.primitiveType(), .integer)
        XCTAssertEqual(try secondParam.type.primitiveType(), .string)
    }

    // MARK: - Service definition
}
