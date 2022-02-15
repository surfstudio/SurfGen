//
//  Templates.swift
//  
//
//  Created by volodina on 15.02.2022.
//

import Foundation
import CodeGenerator

public struct TestTemplates {

    static var baseTemplatePath: String {
        return URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .deletingLastPathComponent() //.../SurfGen
            .appendingPathComponent("Templates/v2/Swift")
            .absoluteString
    }

    static var testOutputPath: String {
        return URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .appendingPathComponent("TestOutputFiles")
            .absoluteString
    }

    static var templateModels: [Template] {
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
