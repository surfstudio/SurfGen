//
//  EndToEndTests.swift
//  
//
//  Created by Dmitry Demyanov on 24.01.2021.
//

import Foundation
import CodeGenerator
import PathKit
import Pipelines
import XCTest

/// This test contains cases for cheking that full generation pipeline works correctly as if user has launched it for some spec
///
/// Cases:
///
/// - Sample service spec is generated correctly
/// - Sample spec with recursive models is generated correctly
class EndToEndTests: XCTestCase {

    func testSampleServiceSpecIsGeneratedCorrectlyForSwift() throws {
        // Arrange

        let specUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/ProjectA/promotions/api.yaml")

        let expectedResultDirectory = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .appendingPathComponent("SampleFiles")
            .appendingPathComponent("Swift")
            .appendingPathComponent("RealSpec")
            .absoluteString

        try specGenerationTestUtil(
            specUrl: specUrl,
            expectedResultDirectory: expectedResultDirectory,
            serviceName: "Promotions",
            templates: TestTemplates.swiftTemplateModels
        )
    }

    func testSpecWithReferenceCyclesIsGeneratedCorrectlyForSwift() throws {
        // Arrange

        let specUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/TestProject/reference_cycles/api.yaml")

        let expectedResultDirectory = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .appendingPathComponent("SampleFiles")
            .appendingPathComponent("Swift")
            .appendingPathComponent("SpecWithCycles")
            .absoluteString

        try specGenerationTestUtil(
            specUrl: specUrl,
            expectedResultDirectory: expectedResultDirectory,
            serviceName: "Promotions",
            templates: TestTemplates.swiftTemplateModels
        )
    }
    
    func testSampleServiceSpecIsGeneratedCorrectlyForKotlin() throws {
        // Arrange

        let specUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/ProjectB/loyalty/api.yaml")

        let expectedResultDirectory = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .appendingPathComponent("SampleFiles")
            .appendingPathComponent("Kotlin")
            .appendingPathComponent("RealSpec")
            .absoluteString

        try specGenerationTestUtil(
            specUrl: specUrl,
            expectedResultDirectory: expectedResultDirectory,
            serviceName: "Loyalty",
            templates: TestTemplates.kotlinTemplateModels
        )
    }
    
    private func specGenerationTestUtil(
        specUrl: URL,
        expectedResultDirectory: String,
        serviceName: String,
        templates: [Template]
    ) throws {
        let expectedFiles = try Path(expectedResultDirectory).children()
            .filter { $0.isResultFile }
            .sorted()

        // Act

        try BuildCodeGeneratorPipelineFactory
            .build(templates: templates,
                   specificationRootPath: "",
                   astNodesToExclude: [],
                   serviceName: serviceName,
                   useNewNullableDefinitionStartegy: false)
            .run(with: specUrl)

        let generatedFiles = try Path(TestTemplates.testOutputPath).children()
            .filter { $0.isResultFile }
            .sorted()

        XCTAssert(!generatedFiles.isEmpty)
        
        // Assert

        // File names are equal
        XCTAssertEqual(expectedFiles.map { $0.lastComponent },
                       generatedFiles.map { $0.lastComponent })

        for i in 0..<expectedFiles.count {
            // File contents are equal
            let exp = try expectedFiles[i].read()
            let ideal = try generatedFiles[i].read()

            if !exp.elementsEqual(ideal) {
                print(expectedFiles[i])
                print(generatedFiles[i])
                print(String(data: exp, encoding: .utf8)!.difference(from: String(data: ideal, encoding: .utf8)!))
            }

            XCTAssertEqual(exp, ideal)
        }

        // Cleanup

        try generatedFiles.forEach { try $0.delete() }
    }
}

private extension Path {
    var isResultFile: Bool {
        return self.extension == "txt"
    }
}
