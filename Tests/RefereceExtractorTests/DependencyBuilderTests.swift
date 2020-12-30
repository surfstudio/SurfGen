//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import XCTest
@testable import ReferenceExtractor

/// Cases
///
/// - If there are no references then there will be empty dependencies
/// - If there are only local references then there will be empty dependencies
/// - If there are references with 1 depth then they will be in dependencies
/// - If there are transitive dependencies then they will be in dependencies
/// - If there are 2 dependencies then they will be in dependencies
/// - If there are 1 dependency with different path value then it will be one dependency
class DependencyBuilderTests: XCTestCase {

    func testIfThereAreNoReferencesThenThereWillBeEmptyDependencies() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let res = try extrator.extract().dependecies

        // Assert

        XCTAssertEqual(res.count, 1)
        XCTAssertEqual(res[0].pathToCurrentFile, rootPath)
        XCTAssertTrue(res[0].dependecies.isEmpty)
    }

    func testIfThereAreOnlyLocalReferencesThenThereWillBeEmptyDependencies() throws {
        // Arrange

        let rootPath = "/file/path"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withLocalRef

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let res = try extrator.extract().dependecies

        // Assert

        XCTAssertEqual(res.count, 1)
        XCTAssertEqual(res[0].pathToCurrentFile, rootPath)
        XCTAssertTrue(res[0].dependecies.isEmpty)
    }

    func testIfThereArereferencesWithOneDepthThenTheyWillBeEmptyDependencies() throws {
        // Arrange

        let rootPath = "/file/path"
        let dependencyPath = "/file/models.yaml"
        let refValue = "models.yaml#/components/schemas/CatalogItem"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withOneFileRef
        fileProvider.files[dependencyPath] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let res = try extrator.extract().dependecies

        // Assert

        XCTAssertEqual(res.count, 2)

        let root = res.first(where: { $0.pathToCurrentFile == rootPath })!

        XCTAssertEqual(root.dependecies.count, 1)
        XCTAssertEqual(root.dependecies[refValue], dependencyPath)

        let rootDep = res.first(where: { $0.pathToCurrentFile == dependencyPath })!

        XCTAssertEqual(rootDep.pathToCurrentFile, dependencyPath)
        XCTAssertEqual(rootDep.dependecies.count, 0)
    }

    func testIfThereAreTransitiveDependenciesThenTheyWillBeInDependencies() throws {
        // Arrange

        // we ccheck tahat if A -> B -> C -> A
        // then each file will have its dependencies

        let aDepPath = "/file/modelsA.yaml"
        let bDepPath = "/file/modelsB.yaml"
        let cDepPath = "/file/modelsC.yaml"

        let aRef = "modelsB.yaml#/components/schemas/AuthRequest"
        let bRef = "modelsC.yaml#/components/schemas/AuthRequest"
        let cRef = "modelsA.yaml#/components/schemas/AuthRequest"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true

        fileProvider.files[aDepPath] = SpecFilesDeclaration.tranditiveDepA
        fileProvider.files[bDepPath] = SpecFilesDeclaration.tranditiveDepB
        fileProvider.files[cDepPath] = SpecFilesDeclaration.tranditiveDepC

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: aDepPath)!, fileProvider: fileProvider)

        // Act

        let res = try extrator.extract().dependecies

        // Assert

        XCTAssertEqual(res.count, 3)

        let aDep = res.first(where: { $0.pathToCurrentFile == aDepPath })!

        XCTAssertEqual(aDep.dependecies.count, 1)
        XCTAssertEqual(aDep.dependecies[aRef], bDepPath)

        let bDep = res.first(where: { $0.pathToCurrentFile == bDepPath })!

        XCTAssertEqual(bDep.dependecies.count, 1)
        XCTAssertEqual(bDep.dependecies[bRef], cDepPath)

        let cDep = res.first(where: { $0.pathToCurrentFile == cDepPath })!

        XCTAssertEqual(cDep.dependecies.count, 1)
        XCTAssertEqual(cDep.dependecies[cRef], aDepPath)
    }

    func testIfThereAreTwoDependenciesThenTheyWillBeInDependencies() throws {
        // Arrange

        let rootPath = "/file/path"

        let dep1Path = "/file/models.yaml"
        let dep2Path = "/file/models2.yaml"

        let dep1Ref = "models.yaml#/components/schemas/CatalogItem"
        let dep2Ref = "models2.yaml#/components/schemas/CatalogItem"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.withTwoDifferentFileRef
        fileProvider.files[dep1Path] = SpecFilesDeclaration.withoutRefs
        fileProvider.files[dep2Path] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let res = try extrator.extract().dependecies

        // Assert

        XCTAssertEqual(res.count, 3)

        let root = res.first(where: { $0.pathToCurrentFile == rootPath })!

        XCTAssertEqual(root.dependecies[dep1Ref], dep1Path)
        XCTAssertEqual(root.dependecies[dep2Ref], dep2Path)
    }

    func testIfThereAreTwoRefsWithDifferentPathesButSameNormalizedValueThenItWillBeOneDependency() throws {
        // Arrange

        let rootPath = "/file/path"

        let depPath = "/file/a/b/modelsA.yaml"

        let dep1Ref = "./a/b/modelsA.yaml#/components/schemas/AuthRequest"
        let dep2Ref = "./a/b/c/../modelsA.yaml#/components/schemas/AuthRequest"

        let fileProvider = FileProviderStub()
        fileProvider.isReadableFile = true
        fileProvider.files[rootPath] = SpecFilesDeclaration.sameNormalizedPathes
        fileProvider.files[depPath] = SpecFilesDeclaration.withoutRefs

        let extrator = try ReferenceExtractor(pathToSpec: URL(string: rootPath)!, fileProvider: fileProvider)

        // Act

        let res = try extrator.extract().dependecies

        // Assert

        XCTAssertEqual(res.count, 2)

        let root = res.first(where: { $0.pathToCurrentFile == rootPath })!

        XCTAssertEqual(root.dependecies[dep1Ref], depPath)
        XCTAssertEqual(root.dependecies[dep2Ref], depPath)
    }
}
