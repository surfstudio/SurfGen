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
class EndToEndTests: XCTestCase {

    func testSampleServiceSpecIsGeneratedCorrectly() throws {
        // Arrange

        let specUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/ProjectA/promotions/api.yaml")

        let expectedResultDirectory = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .appendingPathComponent("SampleFiles")
            .absoluteString

        let expectedFiles = try Path(expectedResultDirectory).children()
            .filter { $0.isResultFile }
            .sorted()

        // Act

        try BuildCodeGeneratorPipelineFactory.build(templates: templateModels, serviceName: "Promotions", useNewNullableDefinitionStartegy: false)
            .run(with: specUrl)

        let generatedFiles = try Path(testOutputPath).children()
            .filter { $0.isResultFile }
            .sorted()

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

private extension EndToEndTests {

    var baseTemplatePath: String {
        return URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .deletingLastPathComponent() //.../SurfGen
            .appendingPathComponent("Templates/v2/Swift")
            .absoluteString
    }

    var testOutputPath: String {
        return URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .appendingPathComponent("TestOutputFiles")
            .absoluteString
    }

    var templateModels: [Template] {
        return [
            Template(type: .service,
                     nameSuffix: "UrlRoute",
                     fileExtension: "txt",
                     templatePath: baseTemplatePath + "/UrlRoute.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "Service",
                     fileExtension: "txt",
                     templatePath: baseTemplatePath + "/Service.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "NetworkService",
                     fileExtension: "txt",
                     templatePath: baseTemplatePath + "/NetworkService.stencil",
                     destinationPath: testOutputPath),
            Template(type: .model,
                     nameSuffix: "Entry",
                     fileExtension: "txt",
                     templatePath: baseTemplatePath + "/Entry.stencil",
                     destinationPath: testOutputPath),
            Template(type: .model,
                     nameSuffix: "Entity",
                     fileExtension: "txt",
                     templatePath: baseTemplatePath + "/Entity.stencil",
                     destinationPath: testOutputPath),
            Template(type: .enum,
                     nameSuffix: nil,
                     fileExtension: "txt",
                     templatePath: baseTemplatePath + "/Enum.stencil",
                     destinationPath: testOutputPath),
            Template(type: .typealias,
                     nameSuffix: nil,
                     fileExtension: "txt",
                     templatePath: baseTemplatePath + "/Typealias.stencil",
                     destinationPath: testOutputPath)
        ]
    }
}

private extension Path {
    var isResultFile: Bool {
        return self.extension == "txt"
    }
}
