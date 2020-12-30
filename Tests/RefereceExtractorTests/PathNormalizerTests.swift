//
//  PathNormalizerTests.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import XCTest

@testable import ReferenceExtractor

class PathNormalizerTests: XCTestCase {

    func testStrings() throws {
        // Arrange

        var data = [
            "/file/path":"/file/path",
            "file/path": "file/path",
            "file/file/file": "file/file/file",
            "file/path/../file": "file/file",
            "file/path/../../file": "file",
            "file/path/../../../file": "",
            "file/path/../../../../": "",
            "../file/path": "",
            "./file/path": "file/path",
            "file/./path": "file/path",
            "a/b/./c/../../": "a" // i checked it on real fs :D
        ]

        // Act - Assert

        for (key, value) in data {
            do {
                let str = try PathNormalizer.normalize(path: key)
                XCTAssertEqual(str, value)
            } catch where value == "" {
                continue
            }
        }
    }
}
