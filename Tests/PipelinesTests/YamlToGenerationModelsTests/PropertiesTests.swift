//
//  PropertiesTests.swift
//  
//
//  Created by Dmitry Demyanov on 20.01.2021.
//

import Foundation
import XCTest
import UtilsForTesting

@testable import CodeGenerator
@testable import Pipelines

/// This test contains cases for cheking that all scenarios which are conected to parsing object properties work
///
/// Cases:
///
/// - Properties definition:
///     - Property with array type is parsed cerrectly

class PropertiesTests: XCTestCase {

    /// Property with array type is parsed correctly
    func testArrayPropertyWillBeParsed() throws {
        // Arrange

        let pathToRoot = "/path/to/services.yaml"
        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files = [pathToRoot: PropertiesTests.yamlWithArrayTypeWillBeParsed]

        var factory = StubGASTTreeFactory(fileProvider: fileProvider)

        var result = [[PathModel]]()

        factory.resultClosure = { (val: [[PathModel]]) throws -> Void in
            result = val
        }

        let pipeline = factory.build()

        // Act

        try pipeline.run(with: URL(string: pathToRoot)!)

        // Assert

        guard
            let requestBody = result[0][0].operations[0].requestModel?.value.content[0],
            case .object(let objectSchema) = requestBody.type,
            let arrayProperty = objectSchema.properties.first
        else {
            XCTFail("Can't extract request model properties from \(result)")
            return
        }

        XCTAssert(arrayProperty.isTypeArray)
        XCTAssertEqual(try arrayProperty.type.arrayType().itemsType.name, "KeyValuePair")
    }
}
