//
//  Templates.swift
//  
//
//  Created by volodina on 15.02.2022.
//

import Foundation
import CodeGenerator

public struct TestTemplates {

    private static var baseTemplatePath: URL {
        return URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .deletingLastPathComponent() //.../SurfGen
    }
    
    static var swiftBaseTemplatePath: String {
        return baseTemplatePath
            .appendingPathComponent("Templates/v2/Swift")
            .absoluteString
    }

    static var kotlinBaseTemplatePath: String {
        return baseTemplatePath
            .appendingPathComponent("Templates/v2/Kotlin/Coroutines")
            .absoluteString
    }
    
    static var testOutputPath: String {
        return URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/EndToEndTests/EndToEndTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/EndToEndTests
            .appendingPathComponent("TestOutputFiles")
            .absoluteString
    }

    static var kotlinTemplateModels: [Template] {
        return [
            Template(type: .service,
                     nameSuffix: "Api",
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Api.stencil",
                     destinationPath: testOutputPath),
            Template(type: .enum,
                     nameSuffix: nil,
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Enum.stencil",
                     destinationPath: testOutputPath),
            Template(type: .model,
                     nameSuffix: "Entry",
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Entry.stencil",
                     destinationPath: testOutputPath),
            Template(type: .model,
                     nameSuffix: "Entity",
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Entity.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "Module",
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Module.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "Repository",
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Repository.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "Interactor",
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Interactor.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "Urls",
                     fileExtension: "txt",
                     templatePath: kotlinBaseTemplatePath + "/Urls.stencil",
                     destinationPath: testOutputPath)
        ]
    }
    
    static var swiftTemplateModels: [Template] {
        return [
            Template(type: .service,
                     nameSuffix: "UrlRoute",
                     fileExtension: "txt",
                     templatePath: swiftBaseTemplatePath + "/UrlRoute.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "Service",
                     fileExtension: "txt",
                     templatePath: swiftBaseTemplatePath + "/Service.stencil",
                     destinationPath: testOutputPath),
            Template(type: .service,
                     nameSuffix: "NetworkService",
                     fileExtension: "txt",
                     templatePath: swiftBaseTemplatePath + "/NetworkService.stencil",
                     destinationPath: testOutputPath),
            Template(type: .model,
                     nameSuffix: "Entry",
                     fileExtension: "txt",
                     templatePath: swiftBaseTemplatePath + "/Entry.stencil",
                     destinationPath: testOutputPath),
            Template(type: .model,
                     nameSuffix: "Entity",
                     fileExtension: "txt",
                     templatePath: swiftBaseTemplatePath + "/Entity.stencil",
                     destinationPath: testOutputPath),
            Template(type: .enum,
                     nameSuffix: nil,
                     fileExtension: "txt",
                     templatePath: swiftBaseTemplatePath + "/Enum.stencil",
                     destinationPath: testOutputPath),
            Template(type: .typealias,
                     nameSuffix: nil,
                     fileExtension: "txt",
                     templatePath: swiftBaseTemplatePath + "/Typealias.stencil",
                     destinationPath: testOutputPath)
        ]
    }
}
