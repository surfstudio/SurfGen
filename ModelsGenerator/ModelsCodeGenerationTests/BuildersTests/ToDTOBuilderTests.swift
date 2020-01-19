//
//  ToDTOBuilderTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import SurfGenKit

class ToDTOBuilderTests: XCTestCase {

    func testToDTOPlainType() {
        let resultString = ToDTOBuilder().buildString(for: .plain("Int"), with: "count", isOptional: true)
        XCTAssert(resultString == "count")
    }

    func testToDTOObjectType() {
        let resultString = ToDTOBuilder().buildString(for: .object("Child"), with: "child", isOptional: true)
        XCTAssert(resultString == "child?.toDTO()")
    }

    func testToDTOArrayPlainType() {
        let resultString = ToDTOBuilder().buildString(for: .array(.plain("String")), with: "numbers", isOptional: true)
        XCTAssert(resultString == "numbers")
    }

    func testToDTOArrayObjectsType() {
        let resultString = ToDTOBuilder().buildString(for: .array(.object("ExpandedData")), with: "expand_data", isOptional: false)
        XCTAssert(resultString == "expandData.toDTO()")
    }

}
