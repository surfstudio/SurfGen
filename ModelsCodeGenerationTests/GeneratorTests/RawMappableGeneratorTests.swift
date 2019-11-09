//
//  RawMappableGeneratorTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import ModelsCodeGeneration

class RawMappableGeneratorTests: XCTestCase {

    func testRawMappableGenerator() {
        let declNode = Node(token: .decl, [Node(token: .name(value: "Login"), [])])

        let expectedCode = "// MARK: - RawMappable\n\nextension LoginEntry: RawMappable {\n    public typealias Raw = Json\n}"
        let generatedCode = try? RawMappableGenerator().generateCode(for: declNode, type: .entry)
    
        XCTAssert(expectedCode == generatedCode)
    }

}
