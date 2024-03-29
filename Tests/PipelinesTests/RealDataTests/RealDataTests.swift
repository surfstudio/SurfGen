//
//  File.swift
//  
//
//  Created by Александр Кравченков on 29.12.2020.
//

import Foundation
import XCTest

@testable import Pipelines

final class RealDataTests: XCTestCase {

    func testProjectACanBeParsedToGenerationModels() throws {
        // Arrange

        let baseUrl = URL(string: #file)! //.../SurfGen/Tests/PipelinesTests/RealDataTests/RealDataTests.swift
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests/RealDataTests
            .deletingLastPathComponent() //.../SurfGen/Tests/PipelinesTests
            .deletingLastPathComponent() //.../SurfGen/Tests
            .appendingPathComponent("Common/ProjectA")

        let urls = [
            baseUrl.appendingPathComponent("auth/api.yaml"),
            baseUrl.appendingPathComponent("billings/api.yaml"),
            baseUrl.appendingPathComponent("catalog/api.yaml"),
            baseUrl.appendingPathComponent("command/api.yaml"),
            baseUrl.appendingPathComponent("common/resources/api.yaml"),
            baseUrl.appendingPathComponent("feedback/api.yaml"),
            baseUrl.appendingPathComponent("help/api.yaml"),
            baseUrl.appendingPathComponent("history_of_payment/api.yaml"),
            baseUrl.appendingPathComponent("payment_card/api.yaml"),
            baseUrl.appendingPathComponent("profile/api.yaml"),
            baseUrl.appendingPathComponent("promotions/api.yaml"),
            baseUrl.appendingPathComponent("push/api.yaml"),
            baseUrl.appendingPathComponent("united_accounts/api.yaml"),
            baseUrl.appendingPathComponent("user/api.yaml")
        ]

        // Act - Assert

        try urls.forEach { url in
            XCTAssertNoThrow(
                try { () throws -> Void in
                    do {
                        _ = try BuildCodeGeneratorPipelineFactory.build(
                            templates: [],
                            specificationRootPath: "",
                            astNodesToExclude: [],
                            serviceName: "",
                            useNewNullableDefinitionStartegy: false
                        ).run(with: url)
                    } catch {
                        print("ERROR for \(url)")
                        print(error.localizedDescription)
                        throw error
                    }
                    print("SUCCESS for \(url)")
                }()
            )
        }
    }
}
