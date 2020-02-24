//
//  FromDTOBuilderTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import SurfGenKit

class FromDTOBuilderTests: XCTestCase {

    func testFromDTOPlainType() {
        let resultString = FromDTOBuilder().buildString(for: .plain("Int"), with: "count", isOptional: true)
        XCTAssertEqual(resultString, "model.count")
    }

    func testFromDTOObjectType() {
        let resultString = FromDTOBuilder().buildString(for: .object("Child"), with: "child", isOptional: true)
        XCTAssertEqual(resultString, ".from(dto: model.child)")
    }

    func testFromDTOArrayPlainType() {
        let resultString = FromDTOBuilder().buildString(for: .array(.plain("String")), with: "numbers", isOptional: true)
        XCTAssertEqual(resultString, "model.numbers")
    }

    func testFromDTOArrayObjectsType() {
        let resultString = FromDTOBuilder().buildString(for: .array(.object("ExpandedData")), with: "expand_data", isOptional: false)
        XCTAssertEqual(resultString, ".from(dto: model.expand_data)")
    }

}
