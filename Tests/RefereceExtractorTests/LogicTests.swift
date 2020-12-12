//
//  TestLogic.swift
//  
//
//  Created by Александр Кравченков on 12.12.2020.
//

@testable import ReferenceExtractor
import XCTest

/// Cases:
///
/// - For spec without $ref no one file will be readed
/// - For spec with local $ref no one file will be readed
/// - For spec with 1-depth $ref only one file will be readed
/// - For spec with 1-depth same $refs only one file will be readed
/// - For spec with 1-depth different $refs same files will be readed
/// - For spec with array which contains dict with refs, all refs will be extracted
class LogicTests: XCTestCase {

    func testForSpecWithoutRefNoOneFileWillBeReaded() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let refs = try extrator.extract()

        // Assert

        // one because we read root spec
        XCTAssertEqual(fileProvider.readCount, 1)
        XCTAssertTrue(refs.isEmpty, "\(refs)")
    }

    func testForSpecWithLocalRefNoOneFileWillBeReaded() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withLocalRef

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let refs = try extrator.extract()

        // Assert

        // one because we read root spec
        XCTAssertEqual(fileProvider.readCount, 1)
        XCTAssertTrue(refs.isEmpty, "\(refs)")
    }

    func testForSpecWithOneDepthRefOnlyOneFileWillBeReaded() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withOneFileRef
        fileProvider.files["/file/models.yaml"] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let refs = try extrator.extract()

        // Assert

        // one because we read root spec
        XCTAssertEqual(fileProvider.readCount, 2)
        XCTAssertEqual(refs.count, 1)
    }

    func testForSpecWithOneDepthSameRefOnlyOneFileWillBeReaded() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withTwoSameFileRef
        fileProvider.files["/file/models.yaml"] = SpecFilesDeclaration.withoutRefs
        fileProvider.files["/file/models2.yaml"] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let refs = try extrator.extract()

        // Assert

        // one because we read root spec
        XCTAssertEqual(fileProvider.readCount, 2)
        XCTAssertEqual(refs.count, 1)
    }

    func testForSpecWithOneDepthDifferentRefSameFilesCountWillBeReaded() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withTwoDifferentFileRef
        fileProvider.files["/file/models.yaml"] = SpecFilesDeclaration.withoutRefs
        fileProvider.files["/file/models2.yaml"] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let refs = try extrator.extract()

        // Assert

        // one because we read root spec
        XCTAssertEqual(fileProvider.readCount, 3)
        XCTAssertEqual(refs.count, 2)
    }

    func testForSpecWithArrayWhichContainsDictWithRefsAllRefsWillBeExtracted() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withArrayWithRefs
        fileProvider.files["/file/models.yaml"] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let refs = try extrator.extract()

        // Assert

        // one because we read root spec
        XCTAssertEqual(fileProvider.readCount, 2)
        XCTAssertEqual(refs.count, 1)
    }
}
