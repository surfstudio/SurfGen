//
//  Tests.swift
//  
//
//  Created by Александр Кравченков on 12.12.2020.
//

@testable import ReferenceExtractor
import XCTest

/// Cases:
///
/// - Error will be thrown for unreadble file in init
/// - Error wont be thrown for readable file in init
///
/// - Error will be thrown for unreadble file in $ref
/// - Error won't be thrown for readble file in $ref
/// - Error will be thrown for wrong encoded file (not utf8)
class ErrorThrowingTests: XCTestCase {

    func testErrorWillBeThrownForUnreadbleFileInInit() {
        // Arrange

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = false

        // Act - Assert
        XCTAssertThrowsError(try ReferenceExtractor(pathToSpec: URL(string: "/file/path")!, fileProvider: fileProvider))
    }

    func testErrorWontBeThrownForReadableFileInInit() {
        // Arrange

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true

        // Act - Assert
        XCTAssertNoThrow(try ReferenceExtractor(pathToSpec: URL(string: "/file/path")!, fileProvider: fileProvider))
    }

    func testErrorWillBeThrownForUnreadbleFileInRef() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withOneFileRef

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        XCTAssertThrowsError(try extrator.extract())
    }

    func testErrorWontBeThrownForReadbleFileInRef() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withOneFileRef
        fileProvider.files["/file/models.yaml"] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        XCTAssertNoThrow(try extrator.extract())
    }

    func testErrorWillBeThrownForWrongEncodedFile() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withOneFileRef
        fileProvider.files["/file/models.yaml"] = Data([0,1,2,3,4,5,6])

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        XCTAssertThrowsError(try extrator.extract())
    }
}
